#!/usr/bin/env ruby

require "opencv-ffi-wrappers"
require "benchmark"
require "../../common/array_statistics"

include CVFFI

infile = "../../images/test_pattern_chart.jpg";
iterations = 1

img = Mat.new CVFFI::cvLoadImageM( infile, CVFFI::CV_LOAD_IMAGE_GRAYSCALE )

class CVFFI::Mat
  def sobel( args = {} )
    dst = twin
    cvSobel( self.to_CvMat, dst.to_CvMat, 
            args[:xorder] || 0, args[:yorder] || 0, args[:apertureSize] || 3 )
    dst
  end
end


def test_function( img )
  img.sobel( xorder: 1 )
end


test_function(img)
test_function(img)

durations = iterations.times.map { |i|
  GC.start
  Benchmark.measure do test_function( img ) end
}

us = durations.map { |d| d.total * 1_000_000_000 }
p us
puts "Ran #{iterations} iterations with mean %.2f  stddev %2.f" % [ us.mean, us.stddev ]

