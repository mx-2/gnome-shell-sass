#!/usr/bin/env ruby

require "fileutils"
require "open3"

Dir.chdir(__dir__)

GDM_WP_FILENAME = "gdm-wallpaper.svg.png"
WRKDIR = "#{ENV["TMPDIR"] || "/tmp"}/_gdm"
WP_SCALE = 2
GST_SYS = "/usr/share/gnome-shell/gnome-shell-theme.gresource"

gnome_version, result = Open3.capture2("gnome-shell --version")
raise "get version failed" unless result.success?
gnome_version = gnome_version.match(/^GNOME Shell (\d+\.\d+)(:?\.\d+)?$/)[1]

FileUtils.mkdir_p("#{WRKDIR}/theme")
FileUtils.mkdir_p("#{WRKDIR}/theme/icons")

width, height = File.open("#{__dir__}/#{GDM_WP_FILENAME}", "rb") do |file|
  magic = file.read(6).unpack("c*")
  if magic != "\x89PNG\r\n".unpack("c*")
    raise "#{GDM_WP_FILENAME} is not a png!"
  end
  file.read(10)
  file.read(8).unpack('NN')
end
width /= WP_SCALE
height /= WP_SCALE

replace_sys = false

gst_in = GST_SYS
gst_out = GST_SYS

ARGV.each do |arg|
  case arg
  when "--create-backup"
    FileUtils.cp(GST_SYS, "#{GST_SYS}.bak")
  when "--use-backup"
    gst_in = "#{GST_SYS}.bak"
  when "--replace-sys"
    replace_sys = true
  else
    raise "Found invalid argument #{arg}!"
  end
end

# Decompile
output, result = Open3.capture2("gresource list #{gst_in}")
raise "decompile failed" unless result.success?

output.split("\n").each do |resource|
  output, result = Open3.capture2("gresource extract #{gst_in} #{resource}")
  raise "extract #{resource} failed" unless result.success?
  File.write("#{WRKDIR}/#{resource.gsub("/org/gnome/shell", "")}", output)
end

# Modify
FileUtils.cp("#{__dir__}/#{GDM_WP_FILENAME}", "#{WRKDIR}/theme/#{GDM_WP_FILENAME}")

css_filename = "#{WRKDIR}/theme/gnome-shell.css"

if ["3.36"].include?(gnome_version)
  css = File.read("#{__dir__}/gnome-shell.3.36.css")
  css = css.gsub(%r!
    (\#lockDialogGroup\ \{
      \s*?background:.*?
      \s*?background-size:\ )\d+px\ \d+px;!x,
  "\\1#{width}px #{height}px;")
else
  raise "Unsupported gnome version."
end

# Compile
File.write(css_filename, css)
files = Dir.glob("#{WRKDIR}/theme/*").map do |file|
  if File.file?(file)
    "    <file>#{file.gsub("#{WRKDIR}/theme/", "")}</file>"
  end
end.compact

File.write "#{WRKDIR}/gnome-shell-theme.gresource.xml", <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme/">
#{files.join("\n")}
  </gresource>
</gresources>
EOF

Dir.chdir("#{WRKDIR}/theme")
_, result = Open3.capture2(
  "glib-compile-resources ../gnome-shell-theme.gresource.xml")
raise "compilation failed" unless result.success?

if replace_sys
  FileUtils.cp("#{WRKDIR}/gnome-shell-theme.gresource", gst_out)
  FileUtils.chmod(0644, gst_out)
  FileUtils.rm_r(WRKDIR, :secure => true)
else
  FileUtils.cp("#{WRKDIR}/gnome-shell-theme.gresource", "#{__dir__}/")
end
