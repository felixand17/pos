module ApplicationHelper
  def find_version_author_name(version)
    user = User.where(id: version).last
    user ? user.name : ''
  end

  def acronym_text(string)
    string.split.map(&:first).join.upcase rescue nil
  end

  def item_status(item)
    flag = nil

    case item.flag
    when 'DRAFT'
      flag = "<i class='fa fa-minus'></i>".html_safe
    when 'PENDING'
      flag = "<i class='fa fa-times'></i>".html_safe
    when 'ONPROGRESS'
      flag = "<i class='fa fa-clock-o'></i>".html_safe
    when 'DELIVER'
      flag = "<i class='fa fa-check'></i>".html_safe
    when 'REJECTED'
      flag = "<i class='fa fa-times'></i>".html_safe
    end
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def item_url(item)
    return edit_pos_order_detail_path(order_id: item.order_id, order_detail_id: item.id) if enable_captain_order

    if item.flag.eql?('DRAFT') || item.flag.eql?('PENDING')
      edit_pos_order_detail_path(order_id: item.order_id, order_detail_id: item.id)
    else
      'javascript:void(0)'
    end
  end

  def block_loader
    text =
      '<div class="overlay" style="display:none;">
        <i class="fa fa-refresh fa-spin"></i>
      </div>'.html_safe
  end

  # Helper for Thermal Printer

  def logo_paper
    logo = File.join(Rails.root, 'app', 'assets', 'images','finalKM.png')
    image = Escpos::Image.new logo

    "\x1b@"+image.to_escpos
  end

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

  def straight_line
    "-"*48
  end

  def start_line
    "*"*48
  end

  def cut_paper
    "\x1B@\x1DV1"
  end

  def blank_space
    "\n"*3
  end
end
