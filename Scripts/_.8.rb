#==============================================================================
# ■ RGSS3 音量調節機能 Ver1.05 by 星潟
#------------------------------------------------------------------------------
# ゲーム内でBGM・BGS・ME・SEの音量を
# プレイヤーの手で変更する事が出来るようになります。
# 
# プレイ中、F5キーを押す事で音量調節用画面を呼び出せます。
# 呼び出しに使用するキーは変更する事が出来ます。
#
# Ver1.01  BGS・SEの音量処理が不適切だった不具合を修正しました。
#
# Ver1.02  bitmapの解放し忘れを修正しました。
#
# Ver1.02X 新たに音量データを格納したVolumeファイルを生成するようになります。
#          タイトル画面を含むゲーム中のあらゆる場面で呼び出せるようになると共に
#          全てのセーブデータの音量調節を一元管理するようになりました。
#
# Ver1.03  データ一元管理版と統合し、いくつかの処理を見直しました。 
#
# Ver1.04  ご指摘があったので一部処理を改修。
#          特に競合が発生していない方は更新の必要はありません。
#
# Ver1.05  ゲージ画像をファイル指定して表示する機能を追加しました。
#          専用規格ですのでご注意ください。
#==============================================================================
module Sound_Control
  
  #音量調節タイプを設定して下さい。
  #0の場合、全セーブデータ共通。
  #1の場合、セーブデータ個別。
  
  TYPE    = 0
  
  #全セーブデータ共通とする場合の音量保存用ファイル名を指定します。
  
  NAME    = "Volume.rvdata2"
  
  #
  
  #空の配列を作成。
  
  SNAME   = []
  
  #BGMの表示名称を指定します。
  
  SNAME[0]   = "BGM"
  
  #BGSの表示名称を指定します。
  
  SNAME[1]   = "BGS"
  
  #MEの表示名称を指定します。
  
  SNAME[2]   = "ME"
  
  #SEの表示名称を指定します。
  
  SNAME[3]   = "SE"
  
  #空の配列を作成。
  
  DEF_VOL = []
  
  #各初期音量を指定します。
  #音量調節タイプがセーブデータ個別の場合
  #タイトル画面とテスト戦闘の音量は毎回初期化されます。
  
  #BGMの初期音量を指定。
  
  DEF_VOL[0] = 100
  
  #BGSの初期音量を指定。
  
  DEF_VOL[1] = 100
  
  #MEの初期音量を指定。
  
  DEF_VOL[2] = 100
  
  #SEの初期音量を指定。
  
  DEF_VOL[3] = 100
  
  #音量調節画面呼び出し用キーを指定して下さい。
  #なお、本来は変更する必要はありません。
  
  KEY = :F5
  
  #カーソルの飾り文字を指定します。
  #デフォルトでは全角二文字もしくは半角四文字までが推奨文字数です。
  #なお、変更する必要はありません。
  #不要な場合はそれぞれ""に変えて下さい
  
  #前
  
  CURSOR_1 = "★☆"
  
  #後
  
  CURSOR_2 = "☆★"
  
  #説明文の内容を設定します。
  #デフォルトでは音量調節画面の使用方法が記載されています。
  
  #見出しとして表示するテキスト。（大きく表示されます）
  
  TITLE = "- 音量調節 -"
  
  #左下・右下に表示するテキストを数値に応じて更に下の方に移動させます。
  #解像度を640×480に拡張している場合は、この値を32に設定すると
  #ちょうどいいかもしれません。
  
  Y_PLUS = 0
  
  #左下に表示するテキスト用配列を用意します。
  
  LTEXT = []
  
  #左下に表示するテキストを指定順に記述します。
  
  LTEXT[0] = "♪上キー　　　　　　：上の項目へ"
  LTEXT[1] = "♪下キー　　　　　　：下の項目へ"
  LTEXT[2] = "♪右キー　　　　　　：音量＋１"
  LTEXT[3] = "♪左キー　　　　　　：音量－１"
  LTEXT[4] = "♪ＳＨＩＦＴ＋右キー：音量＋５"
  LTEXT[5] = "♪ＳＨＩＦＴ＋左キー：音量－５"
  LTEXT[6] = "♪ＣＴＲＬ　　　　　：初期化"
  
  #右下に表示するテキスト用配列を用意します。
  
  RTEXT = []
  
  #左下に表示するテキストを指定順に記述します。
  
  RTEXT[0] = "♪決定キー　　　　　：操作終了"
  RTEXT[1] = "♪キャンセルキー　　：操作終了"
  RTEXT[2] = "♪Ｆ５　　　　　　　：操作終了"
  RTEXT[3] = "♪Ｆ６　　　　　　　：最小化"
  RTEXT[4] = "♪Ｆ７　　　　　　　：最大化"
  RTEXT[5] = "♪Ｆ８　　　　　　　：全て最小化"
  RTEXT[6] = "♪Ｆ９　　　　　　　：全て最大化"
  
  #音量調整のゲージを画像ファイルから呼び出すようにします。
  #VCG0～VCG3はBGM～SEの現在の音量を示すゲージ（明るい部分）です。
  #VCG4～VCG7はBGM～SEの現在の音量を示すゲージ（暗い部分）です。
  #VCG8～VCG11はBGM～SEのゲージのフレーム部分です。
  
  VCG = false
  
end
class Scene_Base
  #--------------------------------------------------------------------------
  # 更新
  #--------------------------------------------------------------------------
  alias update_sound_control update
  def update
    update_sound_control
    sound_control_execute if Input.trigger?(Sound_Control::KEY)
  end
  #--------------------------------------------------------------------------
  # 音量調節画面の背景を作成
  #--------------------------------------------------------------------------
  def create_sound_control_back_sprite(color)
    @back_sprite = Sprite.new
    @back_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @back_sprite.x = (Graphics.width - @back_sprite.width) / 2
    @back_sprite.y = (Graphics.height - @back_sprite.height) / 2
    @back_sprite.z = 10000
    @back_sprite.bitmap.fill_rect(@back_sprite.bitmap.rect, color)
  end
  #--------------------------------------------------------------------------
  # 音量調節カーソルを作成
  #--------------------------------------------------------------------------
  def create_sound_control_cursor(h)
    @big_cursor = Sprite.new
    @big_cursor.bitmap = Bitmap.new(350, 24)
    color = Color.new(255, 255, 255, 50)
    @big_cursor.bitmap.fill_rect(@big_cursor.bitmap.rect, color)
    @big_cursor.bitmap.draw_text(@big_cursor.bitmap.rect,
    Sound_Control::CURSOR_1, 0)
    @big_cursor.bitmap.draw_text(@big_cursor.bitmap.rect,
    Sound_Control::CURSOR_2, 2)
    @big_cursor.x = (@back_sprite.width - @big_cursor.width) / 2
    @big_cursor.y = @back_sprite.y + h * 3
    @big_cursor.z = @back_sprite.z + 1
  end
  #--------------------------------------------------------------------------
  # 音量調節用テキストを作成
  #--------------------------------------------------------------------------
  def create_sound_control_text(h)
    @back_sprite.bitmap.font.size = 32
    @back_sprite.bitmap.draw_text(0, 24,
    @back_sprite.width, @back_sprite.bitmap.font.size, Sound_Control::TITLE, 1)
    @back_sprite.bitmap.font.size = 20
    Sound_Control::LTEXT.each_with_index {|text, i|
    @back_sprite.bitmap.draw_text(12,   h * (i + 10) + Sound_Control::Y_PLUS,
    @back_sprite.width, 24, text, 0)
    }
    Sound_Control::RTEXT.each_with_index {|text, i|
    @back_sprite.bitmap.draw_text(@back_sprite.bitmap.width / 2 + 12,
    h * (i + 10) + Sound_Control::Y_PLUS, @back_sprite.width, 24, text, 0)
    }
    @back_sprite.bitmap.font.size = 24
    4.times {|i| @back_sprite.bitmap.draw_text(
    @big_cursor.x + 48, h * (i * 2 + 3), 40, 24, Sound_Control::SNAME[i], 2)}
  end
  #--------------------------------------------------------------------------
  # 音量調節ゲージを作成
  #--------------------------------------------------------------------------
  def create_sound_control_gauge(h)
    @gauge_sprite = []
    unless Sound_Control::VCG
      color = []
      color.push(Color.new(128, 0, 0))
      color.push(Color.new(255, 128, 128))
      color.push(Color.new(0, 0, 128))
      color.push(Color.new(128, 128, 255))
      color.push(Color.new(128, 128, 0))
      color.push(Color.new(255, 255, 128))
      color.push(Color.new(0, 128, 0))
      color.push(Color.new(128, 255, 128))
      color.push(Color.new(32, 0, 0))
      color.push(Color.new(0, 0, 32))
      color.push(Color.new(32, 32, 0))
      color.push(Color.new(0, 32, 0))
      color.push(Color.new(64, 0, 0))
      color.push(Color.new(0, 0, 64))
      color.push(Color.new(64, 64, 0))
      color.push(Color.new(0, 64, 0))
      color.push(Color.new(128, 64, 64))
      color.push(Color.new(64, 64, 128))
      color.push(Color.new(128, 128, 64))
      color.push(Color.new(64, 128, 64))
    end
    4.times {|i|
    @gauge_sprite.push(Sprite.new)
    if Sound_Control::VCG
      @gauge_sprite[i].bitmap = Cache.system("VCG" + i.to_s)
    else
      @gauge_sprite[i].bitmap = Bitmap.new(120, 12)
      @gauge_sprite[i].bitmap.gradient_fill_rect(
      @gauge_sprite[i].bitmap.rect, color[i * 2], color[i * 2 + 1])
    end
    @gauge_sprite[i].x = (@back_sprite.x + @back_sprite.width - @gauge_sprite[i].bitmap.width) / 2
    @gauge_sprite[i].y = @back_sprite.y + h * (i * 2 + 3) + 6
    @gauge_sprite[i].z = @back_sprite.z + 2
    }
    4.times {|i|
    @gauge_sprite.push(Sprite.new)
    if Sound_Control::VCG
      @gauge_sprite[i + 4].bitmap = Cache.system("VCG" + (i + 4).to_s)
    else
      @gauge_sprite[i + 4].bitmap = Bitmap.new(120, 12)
      @gauge_sprite[i + 4].bitmap.fill_rect(@gauge_sprite[i + 4].bitmap.rect, color[i + 8])
    end
    @gauge_sprite[i + 4].x = @gauge_sprite[i].x + @gauge_sprite[i].width - (@gauge_sprite[i].width * (100 - $game_system.m_v[i]) / 100.0).truncate
    @gauge_sprite[i + 4].y = @back_sprite.y + h * (i * 2 + 3) + 6
    @gauge_sprite[i + 4].z = @back_sprite.z + 3
    @gauge_sprite[i + 4].zoom_x = (100 - $game_system.m_v[i]) / 100.0
    }
    4.times {|i|
    @gauge_sprite.push(Sprite.new)
    if Sound_Control::VCG
      @gauge_sprite[i + 8].bitmap = Cache.system("VCG" + (i + 8).to_s)
    else
      @gauge_sprite[i + 8].bitmap = Bitmap.new(124, 16)
      @gauge_sprite[i + 8].bitmap.gradient_fill_rect(
      @gauge_sprite[i + 8].bitmap.rect, color[i + 12], color[i + 16])
    end
    @gauge_sprite[i + 8].x = @gauge_sprite[i].x - 2
    @gauge_sprite[i + 8].y = @back_sprite.y + h * (i * 2 + 3) + 4
    @gauge_sprite[i + 8].z = @back_sprite.z + 1
    }
  end
  #--------------------------------------------------------------------------
  # 音量調節ゲージの更新
  #--------------------------------------------------------------------------
  def sound_control_gauge_text_update(number, h, color)
    @back_sprite.bitmap.clear_rect(
    @big_cursor.x + @big_cursor.width - 116, h * (number * 2 + 3), 64, 24)
    @back_sprite.bitmap.fill_rect(
    @big_cursor.x + @big_cursor.width - 116, h * (number * 2 + 3), 64, 24, color)
    @back_sprite.bitmap.draw_text(
    @big_cursor.x + @big_cursor.width - 116, h * (number * 2 + 3), 64, 24, $game_system.m_v[number], 2)
    @gauge_sprite[number + 4].x = @gauge_sprite[number].x + @gauge_sprite[number].width - (@gauge_sprite[number].width * (100 - $game_system.m_v[number]) / 100.0).truncate
    @gauge_sprite[number + 4].zoom_x = (100 - $game_system.m_v[number]) / 100.0
    case number
    when 0;RPG::BGM::last.play
    when 1;RPG::BGS::last.play
    end
  end
  #--------------------------------------------------------------------------
  # 音量調節の実行
  #--------------------------------------------------------------------------
  def sound_control_execute
    Sound.play_ok
    color = Color.new(0, 0, 10, 200)
    create_sound_control_back_sprite(color)
    h = 24
    create_sound_control_cursor(h)
    create_sound_control_text(h)
    create_sound_control_gauge(h)
    4.times {|i| @back_sprite.bitmap.draw_text(@big_cursor.x + @big_cursor.width - 116, h * (i * 2 + 3), 64, 24, $game_system.m_v[i], 2)}
    data_index = 0
    loop do
      Graphics.update
      Input.update
      Graphics.frame_count -= 1
      if Input.trigger?(Input::UP)
        Sound.play_cursor
        data_index -= 1
        data_index = 3 if data_index < 0
        @big_cursor.y = @back_sprite.y + h * (data_index * 2 + 3)
      elsif Input.trigger?(Input::DOWN)
        Sound.play_cursor
        data_index += 1
        data_index = 0 if data_index > 3
        @big_cursor.y = @back_sprite.y + h * (data_index * 2 + 3)
      elsif Input.trigger?(Input::LEFT) or Input.repeat?(Input::LEFT)
        predata = $game_system.m_v[data_index]
        data = 1 * (Input.press?(Input::A) ? 5 : 1)
        $game_system.m_v[data_index] = [[$game_system.m_v[data_index] - data, 100].min, 0].max
        sound_control_gauge_text_update(data_index, h, color)
        Sound.play_cursor if predata != $game_system.m_v[data_index]
      elsif Input.trigger?(Input::RIGHT) or Input.repeat?(Input::RIGHT)
        predata = $game_system.m_v[data_index]
        data = 1 * (Input.press?(Input::A) ? 5 : 1)
        $game_system.m_v[data_index] = [[$game_system.m_v[data_index] + data, 100].min, 0].max
        sound_control_gauge_text_update(data_index, h, color)
        Sound.play_cursor if predata != $game_system.m_v[data_index]
      elsif Input.trigger?(:CTRL)
        predata = $game_system.m_v
        $game_system.m_v = Sound_Control::DEF_VOL.clone
        4.times {|i| sound_control_gauge_text_update(i, h, color)}
        Sound.play_cursor if predata != $game_system.m_v
      elsif Input.trigger?(Input::F6)
        predata = $game_system.m_v[data_index]
        $game_system.m_v[data_index] = 0
        sound_control_gauge_text_update(data_index, h, color)
        Sound.play_cursor if predata != $game_system.m_v[data_index]
      elsif Input.trigger?(Input::F7)
        predata = $game_system.m_v[data_index]
        $game_system.m_v[data_index] = 100
        sound_control_gauge_text_update(data_index, h, color)
        Sound.play_cursor if predata != $game_system.m_v[data_index]
      elsif Input.trigger?(Input::F8)
        predata = $game_system.m_v
        4.times {|i|
        $game_system.m_v[i] = 0
        sound_control_gauge_text_update(i, h, color)
        }
        Sound.play_cursor if predata != $game_system.m_v
      elsif Input.trigger?(Input::F9)
        predata = $game_system.m_v
        4.times {|i|
        $game_system.m_v[i] = 100
        sound_control_gauge_text_update(i, h, color)
        }
        Sound.play_cursor if predata != $game_system.m_v
      elsif Input.trigger?(Input::F5) or Input.trigger?(Input::B) or Input.trigger?(Input::C)
        $game_system.vd_save
        break
      end
      @big_cursor.update
      @back_sprite.update
      12.times {|i| @gauge_sprite[i].update}
    end
    Sound.play_cancel
    @back_sprite.bitmap.dispose;@back_sprite.dispose;@back_sprite = nil
    @big_cursor.bitmap.dispose;@big_cursor.dispose;@big_cursor = nil
    12.times {|i| @gauge_sprite[i].bitmap.dispose;@gauge_sprite[i].dispose;@gauge_sprite[i] = nil}
  end
end
class << DataManager
  #--------------------------------------------------------------------------
  # セーブデータの展開
  #--------------------------------------------------------------------------
  alias extract_save_contents_first_volume extract_save_contents
  def extract_save_contents(contents)
    extract_save_contents_first_volume(contents)
    $game_system.m_v = $game_system.m_v_make if Sound_Control::TYPE == 0
  end
end
class Game_System
  attr_accessor :m_v
  #--------------------------------------------------------------------------
  # 音量データの作成
  #--------------------------------------------------------------------------
  def m_v_make
    case Sound_Control::TYPE
    when 0;Dir.glob(Sound_Control::NAME).empty? ? vd_save : vd_load
    when 1;@m_v = Sound_Control::DEF_VOL.clone
    end
  end
  #--------------------------------------------------------------------------
  # 音量データのセーブ
  #--------------------------------------------------------------------------
  def vd_save
    @m_v ||= Sound_Control::DEF_VOL.clone
    save_data(@m_v,Sound_Control::NAME) if Sound_Control::TYPE == 0
  end
  #--------------------------------------------------------------------------
  # 音量データのロード
  #--------------------------------------------------------------------------
  def vd_load
    @m_v = load_data(Sound_Control::NAME)
  end
end
class RPG::AudioFile
  def sound_control(s)
    @volume = (@true_volume ||= @volume) * s.to_f / 100
  end
end
class RPG::BGM < RPG::AudioFile
  alias play_sc play unless $!
  def play(pos = 0)
    $game_system.m_v_make unless $game_system.m_v
    sound_control($game_system.m_v[0])
    play_sc(pos)
  end
end
class RPG::BGS < RPG::AudioFile
  alias play_sc play unless $!
  def play(pos = 0)
    $game_system.m_v_make unless $game_system.m_v
    sound_control($game_system.m_v[1])
    play_sc(pos)
  end
end
class RPG::ME < RPG::AudioFile
  alias play_sc play unless $!
  def play
    $game_system.m_v_make unless $game_system.m_v
    sound_control($game_system.m_v[2])
    play_sc
  end
end
class RPG::SE < RPG::AudioFile
  alias play_sc play unless $!
  def play
    $game_system.m_v_make unless $game_system.m_v
    sound_control($game_system.m_v[3])
    play_sc
  end
end