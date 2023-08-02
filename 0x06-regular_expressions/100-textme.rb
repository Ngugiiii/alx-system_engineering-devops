#!/usr/bin/env ruby
# scrip output: [SENDER],[RECEIVER],[FLAGS]
puts ARGV[0].scan(/(?<=from:|to:|flags:)(.+?)(?=\])/).join(",")
