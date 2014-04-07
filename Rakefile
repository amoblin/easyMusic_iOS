name="MusicFeeling"
infoFile = "\`pwd\`/#{name}/#{name}-Info"

task :xcode do |t|
  sh "xcodebuild -xcworkspace #{name}.xcworkspace -scheme #{name} -configuration Release -sdk iphoneos7.0 -derivedDataPath . clean"
  sh "xcodebuild -xcworkspace #{name}.xcworkspace -scheme #{name} -configuration Release -sdk iphoneos7.0 -derivedDataPath ."
  File.directory?"/tmp/#{name}" or `mkdir /tmp/#{name}`
  sh "rm -rf /tmp/#{name}/#{name}.app"
  sh "cp -rf Build/Products/Release/#{name}.app /tmp/#{name}/#{name}.app"
end

task :info do |t|
  puts `defaults read #{infoFile} CFBundleShortVersionString`
  puts `defaults read #{infoFile} CFBundleVersion`
end

task :dmg => :xcode do |t|
  tag = `git describe --tag`
  filename = "#{name}_%s.dmg" % tag.rstrip
  sh "ln -sf /Applications /tmp/#{name}"
  sh "rm -rf ~/Downloads/%s" % filename
  sh "hdiutil create ~/Downloads/%s -srcfolder /tmp/#{name}" % filename
  sh "cp ~/Downloads/%s /tmp" % filename
end

task :tag do |t|
  puts `defaults write #{infoFile} CFBundleShortVersionString 0.1`
end
