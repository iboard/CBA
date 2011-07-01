# Use <code>sc(:symbol[,:symbol,...])</code> to display special html-characters
module SpecialCharacters

  BR="\n<br/>".html_safe
  POINTER_RIGHT="&#08594;"
  POINTER_LEFT="&#08592;"
  NBSP="&nbsp;"
  SP="&nbsp;"
  OK="&#10004;"
  NOT="&#10008;"
  CLOSE="&#08855;"
  ESC="&#08855;"
  ADD="&#10010;"
  REMOVE="&#10007;"
  FON="&#09990;"
  MAIL="&#09993;"
  COMMENT="&#09997;"
  EDIT="&#09998;"
  UNFLAGED="&#09872;"
  FLAGED="&#09873;"
  STAR="&#10025;"
  STAR_SELECTED="&#10026;"
  APOSTROPHY_OPEN="&#10077;"
  APOSTROPHY_CLOSE="&#10078;"

  CHARACTERS={
      :br                      => BR             ,
      :pointer_right           => POINTER_RIGHT  ,
      :pr                      => POINTER_RIGHT  ,
      :pl                      => POINTER_LEFT   ,
      :nbsp                    => NBSP           ,
      :sp                      => SP             ,
      :ok                      => OK             ,
      :not                     => NOT            ,
      :failed                  => NOT            ,
      :close                   => CLOSE          ,
      :esc                     => ESC            ,
      :add                     => ADD            ,
      :remove                  => REMOVE         ,
      :fon                     => FON            ,
      :mail                    => MAIL           ,
      :comment                 => COMMENT        ,
      :edit                    => EDIT           ,
      :unflaged                => UNFLAGED       ,
      :flaged                  => FLAGED         ,
      :star                    => STAR           ,
      :star_selected           => STAR_SELECTED  ,
      :apostrophy_open         => APOSTROPHY_OPEN,
      :apostrophy_close        => APOSTROPHY_CLOSE
  }

  # <code>sc([:br,:pr,:close])</code> will return one html-string of special
  # characters and html-tags. <b><br />->X</b>
  def sc(*names)
    n = []
    while x = names.shift
      n << x
    end
    begin
      rc = ""
      n.each{ |c| rc += CHARACTERS[c] }
      rc.html_safe
    rescue => e
      "SPECIAL CHAR #{names.inspect} NOT DEFINED IN #{__FILE__} - ERROR #{e.message}"
    end
  end

end
