# exercise 10.5.6
module MicropostsHelper

  def wrap(content)
    # mapはcollectの別名
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      # 空の空白文字 rawを使うのでuni-codeの空白文字を指定
      zero_width_space = '&#8203;'
      regex = /.{1,#{max_width}}/
      # text.scan(pattern) 引数で指定した正規表現のパターンとマッチする部分を文字列から全て取り出し、配列にして返す
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end
end
