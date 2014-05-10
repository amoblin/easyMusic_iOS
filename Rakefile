# -*- coding: utf-8 -*-

task :default do |t|
  puts `defaults read #{$infoFile} CFBundleShortVersionString`
  puts $revision
  puts `git log --pretty=oneline|wc -l`
end

# for OS X App
task :dmg => :xcode do |t|
  tag = `git describe --tag`
  filename = "#{name}_%s.dmg" % tag.rstrip
  sh "ln -sf /Applications /tmp/#{name}"
  sh "rm -rf ~/Downloads/%s" % filename
  sh "hdiutil create ~/Downloads/%s -srcfolder /tmp/#{name}" % filename
  sh "cp ~/Downloads/%s /tmp" % filename
end

task :tag do |t|
  puts `defaults write #{$infoFile} CFBundleShortVersionString 2.1.1`
end

task :tr do |t|
  `find . -name "*.[hm]" | xargs sed -Ee 's/ +$$//g' -i ""`
  `find . -name "*.[hm]" | xargs sed -i .bak "s/^[ ]*$//g"`
  puts `find . -name "*.bak"| xargs rm -f`
end

