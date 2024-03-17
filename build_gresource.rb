#!/usr/bin/env ruby

require "fileutils"
require "getoptlong"
require "open3"

Dir.chdir(__dir__)
SRCDIR = if __dir__ == "/usr/share/themes/good-old-shell/utils"
    "/usr/share/themes/good-old-shell/gnome-shell"
  else
    "./"
  end
WRKDIR = "#{ENV["TMPDIR"] || "/tmp"}/_gdm"

gnome_version, result = Open3.capture2("gnome-shell --version")
raise "get version failed" unless result.success?
gnome_version = gnome_version.match(/^GNOME Shell (\d+)/)[1]
if gnome_version != "46"
  raise "Unsupported gnome version."
end

create_backup = false
gst_in = "/usr/share/gnome-shell/gnome-shell-theme.gresource"
gst_out = gst_in
install = false

opts = GetoptLong.new(
  ["--create-backup", GetoptLong::NO_ARGUMENT],
  ["--gst-in", GetoptLong::REQUIRED_ARGUMENT],
  ["--install", GetoptLong::NO_ARGUMENT],
  ["--use-backup", GetoptLong::NO_ARGUMENT],
)

opts.each do |opt, arg|
  case opt
  when "--create-backup"
    create_backup = true
  when "--gst-in"
    gst_in = arg
  when "--install"
    install = true
  when "--use-backup"
    gst_in = "#{gst_in}.bak"
  else
    raise "Found invalid argument #{arg}!"
  end
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
if File.file?("#{SRCDIR}/icons/no-events.svg")
  FileUtils.cp("#{SRCDIR}/icons/no-events.svg", "#{WRKDIR}/theme/")
end
if File.file?("#{SRCDIR}/icons/no-notifications.svg")
  FileUtils.cp("#{SRCDIR}/icons/no-notifications.svg", "#{WRKDIR}/theme/")
end

css_filename = "#{WRKDIR}/theme/gnome-shell.css"
css_file_prefix = css_filename.sub(/\.css$/, "")
css = File.read("#{SRCDIR}/gnome-shell.css")
css = css.gsub("overview-wallpaper.png", "file://#{File.expand_path("#{SRCDIR}/overview-wallpaper.png")}")
File.write("#{css_file_prefix}-dark.css", css)
File.write("#{css_file_prefix}-high-contrast.css", css)
File.write("#{css_file_prefix}-light.css", css)

# Compile
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

if install
  FileUtils.cp("#{WRKDIR}/gnome-shell-theme.gresource", gst_out)
  FileUtils.chmod(0644, gst_out)
  FileUtils.rm_r(WRKDIR, :secure => true)
else
  FileUtils.cp("#{WRKDIR}/gnome-shell-theme.gresource", "#{__dir__}/")
end
