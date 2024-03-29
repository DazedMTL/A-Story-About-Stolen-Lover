#==============================================================================
# ■ RGSS3 メッセージスキップ機能 Ver1.02 by 星潟
#------------------------------------------------------------------------------
# メッセージウィンドウに表示された文章を一気に読み飛ばします。
# テストモード限定化機能と、特定のスイッチがONの時だけ
# メッセージスキップを有効にする機能も併せて持っています。
#------------------------------------------------------------------------------
# Ver1.01 入力待ち無視（\^）が無効になる不具合を修正しました。
# Ver1.02 強制ウェイトの変更機能・テロップ高速化機能を追加。
#============================================================================== 
module M_SKIP
  
  #メッセージスキップの効果をテストモードに限定するか？
  #trueでテストモード限定、falseで常時
  
  T_LIMT = false
  
  #テロップも高速化するか？
  
  SCROLL = true
  
  #テロップを高速化する場合の速度を指定。
  
  SCROLS = 25
  
  #メッセージスキップ有効化スイッチIDの設定。
  #0にするとスイッチによる判定は消滅。(常時)
  #1以上にすると、そのスイッチがONの時のみメッセージスキップ有効。
  
  SWITID = 0
  
  #メッセージの強制ウェイトを設定。(デフォルトでは10。1以上を推奨)
  
  WAIT = 0
  
  #メッセージスキップに使用するキーの設定。
  #文字送りキーとしても機能します。
  #nilにするとメッセージスキップ機能全てを無効化。
  
  KEY    = :CTRL
  
  #--------------------------------------------------------------------------
  # スキップ封印判定
  #--------------------------------------------------------------------------
  def self.seal
    (T_LIMT ? ($TEST or $BTEST) : true) &&
    (SWITID == 0 ? true : $game_switches[SWITID]) &&
    KEY && Input.press?(M_SKIP::KEY)
  end
  
end
class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_mb update
  def update
    if M_SKIP.seal
      @pause_skip = true
      @show_fast = true
    end
    update_mb
  end
  #--------------------------------------------------------------------------
  # 入力待ち処理
  #--------------------------------------------------------------------------
  def input_pause
    return if M_SKIP.seal
    self.pause = true
    wait(M_SKIP::WAIT)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C) || M_SKIP.seal
    Input.update
    self.pause = false
  end
end
class Window_ScrollText < Window_Base
  #--------------------------------------------------------------------------
  # スクロール速度の取得
  #--------------------------------------------------------------------------
  alias scroll_speed_skip scroll_speed
  def scroll_speed
    if !$game_message.scroll_no_fast && M_SKIP::SCROLL && M_SKIP.seal
      M_SKIP::SCROLS
    else
      scroll_speed_skip
    end
  end
end