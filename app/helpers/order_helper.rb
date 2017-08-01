module OrderHelper
  def txt_normal
   [ 0x1b, 0x21, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Normal text
  end

  def txt_2height
   [ 0x1b, 0x21, 0x10 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Double height text
  end

  def txt_2width
   [ 0x1b, 0x21, 0x20 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Double width text
  end

  def txt_4square
   [ 0x1b, 0x21, 0x30 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Quad area text
  end

  def txt_underl_off
   [ 0x1b, 0x2d, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Underline font OFF
  end

  def txt_underl_on
   [ 0x1b, 0x2d, 0x01 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Underline font 1
  end

  def txt_underl2_on
   [ 0x1b, 0x2d, 0x02 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Underline font 2
  end

  def txt_bold_off
   [ 0x1b, 0x45, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Bold font OFF
  end

  def txt_bold_on
   [ 0x1b, 0x45, 0x01 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Bold font ON
  end

  def txt_font_a
   [ 0x1b, 0x4d, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Font type A
  end

  def txt_font_b
   [ 0x1b, 0x4d, 0x01 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Font type B
  end

  def txt_align_lt
   [ 0x1b, 0x61, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Left justification
  end

  def txt_align_ct
   [ 0x1b, 0x61, 0x01 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Centering
  end

  def txt_align_rt
   [ 0x1b, 0x61, 0x02 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Right justification
  end

  def txt_invert_on
   [ 0x1d, 0x42, 0x01 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Inverted color text
  end

  def txt_invert_off
   [ 0x1d, 0x42, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Inverted color text
  end

  def txt_color_black
   [ 0x1b, 0x72, 0x00 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Default Color
  end

  def txt_color_red
   [ 0x1b, 0x72, 0x01 ].flatten.pack('U*').force_encoding("ASCII-8BIT")        # Alternative Color (Usually Red)
  end
end
