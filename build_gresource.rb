#!/usr/bin/env ruby

require "fileutils"
require "getoptlong"
require "open3"

Dir.chdir(__dir__)
WRKDIR = "#{ENV["TMPDIR"] || "/tmp"}/_gdm"

gnome_version, result = Open3.capture2("gnome-shell --version")
raise "get version failed" unless result.success?
gnome_version = gnome_version.match(/^GNOME Shell (\d+\.\d+)(:?\.\d+)?$/)[1]
if gnome_version.match?(/^4\d\./)
  gnome_version = gnome_version.match(/^(\d+)\./)[1]
end

create_backup = false
gst_in = "/usr/share/gnome-shell/gnome-shell-theme.gresource"
gst_out = gst_in
replace_sys = false
wp_scale = 1
wp_path = "/opt/gdm-wallpaper/wallpaper.png"

opts = GetoptLong.new(
  ["--create-backup", GetoptLong::NO_ARGUMENT],
  ["--gst-in", GetoptLong::REQUIRED_ARGUMENT],
  ["--hidpi", GetoptLong::REQUIRED_ARGUMENT],
  ["--replace-sys", GetoptLong::NO_ARGUMENT],
  ["--use-backup", GetoptLong::NO_ARGUMENT],
  ["--wallpaper", GetoptLong::REQUIRED_ARGUMENT],
)

opts.each do |opt, arg|
  case opt
  when "--create-backup"
    create_backup = true
  when "--gst-in"
    gst_in = arg
  when "--hidpi"
    wp_scale = arg.to_i
  when "--replace-sys"
    replace_sys = true
  when "--use-backup"
    gst_in = "#{gst_in}.bak"
  when "--wallpaper"
    wp_path = arg
  else
    raise "Found invalid argument #{arg}!"
  end
end

raise "#{wp_path} does not exist" unless File.file?(wp_path)
if File.expand_path(wp_path) != wp_path
  raise "#{wp_path} is not an absolute path"
end
width, height = File.open(wp_path, "rb") do |file|
  magic = file.read(6).unpack("c*")
  if magic != "\x89PNG\r\n".unpack("c*")
    raise "#{wp_path} is not a png!"
  end
  file.read(10)
  file.read(8).unpack('NN').map { |x| x / wp_scale }
end

if create_backup
  raise "Cannot create backup if using backup" if gst_in.match?(/\.bak$/)
  FileUtils.cp(gst_in, "#{gst_in}.bak")
end

# Decompile
output, result = Open3.capture2("gresource list #{gst_in}")
raise "decompile failed" unless result.success?

output.split("\n").each do |resource|
  output, result = Open3.capture2("gresource extract #{gst_in} #{resource}")
  raise "extract #{resource} failed" unless result.success?
  resource_name = resource.gsub("/org/gnome/shell", "")
  FileUtils.mkdir_p("#{WRKDIR}/#{File.dirname(resource_name)}")
  File.write("#{WRKDIR}/#{resource_name}", output)
end

# Modify
if File.file?("#{__dir__}/icons/no-events.svg")
  FileUtils.cp("#{__dir__}/icons/no-events.svg", "#{WRKDIR}/theme/")
end
if File.file?("#{__dir__}/icons/no-notifications.svg")
  FileUtils.cp("#{__dir__}/icons/no-notifications.svg", "#{WRKDIR}/theme/")
end
FileUtils.cp("#{__dir__}/overview-wallpaper.svg", "#{WRKDIR}/theme/")

css_filename = "#{WRKDIR}/theme/gnome-shell.css"
if ["3.36", "3.38", "40"].include?(gnome_version)
  css = File.read("#{__dir__}/gnome-shell.#{gnome_version}.css")
  css = css.gsub(%r!
    (\#lockDialogGroup\ \{
      \s*?background:\ ).*?
      \s*?background-size:\ \d+px\ \d+px;!x,
      "\\1url(file://#{wp_path});\n" +
  "  background-size: #{width}px #{height}px;")
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
