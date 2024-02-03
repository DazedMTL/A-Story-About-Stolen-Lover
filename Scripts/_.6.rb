#==============================================================================
# ■ RGSS3 メニューコマンド＋ ver 1.01　本体プログラム
#------------------------------------------------------------------------------
# 　配布元:
#     白の魔 http://izumiwhite.web.fc2.com/
#
# 　利用規約:
#     RPGツクールVX Aceの正規の登録者のみご利用になれます。
#     利用報告・著作権表示とかは必要ありません。
#     改造もご自由にどうぞ。
#     何か問題が発生しても責任は持ちません。
#==============================================================================


#--------------------------------------------------------------------------
# ★ 初期設定。
#    コマンドの順番、コマンド無効化スイッチ等の指定
#--------------------------------------------------------------------------
module WD_menuplus_ini
  
  #メニューコマンドの追加
  #   1 : アイテム
  #   2 : スキル
  #   3 : 装備
  #   4 : ステータス
  #   5 : 並び替え
  #   6 : セーブ
  #   7 : ゲーム終了
  #  11 : アイテム図鑑(白の魔)
  #  12 : 魔物図鑑(白の魔)
  #  13 : アクター預かり所(白の魔)
  #  14 : アイテム合成(白の魔)
  #  15 : スキルポイント振り分けシステム(白の魔)
  Command_list    = [1,2,3,4,5,6,7]
 
  #コマンド無効化スイッチ番号。(0で無効化無し)
  #メニューコマンドの順番と同じ順番でスイッチ番号を指定。
  #指定したスイッチがONの時、メニュー画面のコマンドがグレーになり、
  #選択できなくなります。
  Command_no_sw1  = [0,0,0,0,0,0,0]
  
  #コマンド削除スイッチ番号。(0で削除無し)
  #メニューコマンドの順番と同じ順番でスイッチ番号を指定。
  #指定したスイッチがONの時、メニュー画面のコマンドが表示されなくなり、
  #選択できなくなります。
  Command_no_sw2  = [0,0,24,0,24,0,0]
  
end
module Vocab

  # メニュー画面に表示されるコマンド名
  ItemDic         = "アイテム図鑑"      #アイテム図鑑(白の魔)
  MonsDic         = "魔物図鑑"          #魔物図鑑(白の魔)
  MembChan        = "編成"              #アクター預かり所(白の魔)
  ItemSyn         = "アイテム合成"      #アイテム合成(白の魔)
  SpDev           = "SP 振り分け"       #スキルポイント振り分けシステム(白の魔)

end



class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias wd_orig_create_command_window007 create_command_window
  def create_command_window
    wd_orig_create_command_window007
    @command_window.set_handler(:item_dic,    method(:command_itemdictionary))
    @command_window.set_handler(:mons_dic,    method(:command_monsterdictionary))
    @command_window.set_handler(:memb_chan,   method(:command_memberchange))
    @command_window.set_handler(:item_syn,    method(:command_itemynthesis))
    @command_window.set_handler(:sp_dev,      method(:command_personal))
  end
  #--------------------------------------------------------------------------
  # ● 個人コマンド［決定］
  #--------------------------------------------------------------------------
  def on_personal_ok
    case @command_window.current_symbol
    when :skill
      SceneManager.call(Scene_Skill)
    when :equip
      SceneManager.call(Scene_Equip)
    when :status
      SceneManager.call(Scene_Status)
    when :sp_dev  #スキルポイント振り分けシステム
      command_spdevide
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド［アイテム図鑑］
  #--------------------------------------------------------------------------
  def command_itemdictionary
    SceneManager.call(Scene_ItemDictionary)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［魔物図鑑］
  #--------------------------------------------------------------------------
  def command_monsterdictionary
    SceneManager.call(Scene_MonsterDictionary)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［アクター預かり所］
  #--------------------------------------------------------------------------
  def command_memberchange
    SceneManager.call(Scene_MemberChange)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［アイテム合成］
  #--------------------------------------------------------------------------
  def command_itemynthesis
    SceneManager.call(Scene_ItemSynthesis)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［スキルポイント振り分けシステム］
  #--------------------------------------------------------------------------
  def command_spdevide
    SceneManager.call(Scene_SkillDevide)
  end
end


class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成(再定義)
  #--------------------------------------------------------------------------
  def make_command_list
    WD_menuplus_ini::Command_list.each_with_index do |command_id, i|
      if WD_menuplus_ini::Command_no_sw2[i] != nil
        if WD_menuplus_ini::Command_no_sw2[i] > 0
          if $game_switches[WD_menuplus_ini::Command_no_sw2[i]]
            next
          end
        end
      end
      enabled = true
      if WD_menuplus_ini::Command_no_sw1[i] != nil
        if WD_menuplus_ini::Command_no_sw1[i] > 0
          if $game_switches[WD_menuplus_ini::Command_no_sw1[i]]
            enabled = false
          end
        end
      end
      add_each_command(command_id, enabled)
    end
  end
  #--------------------------------------------------------------------------
  # ● 各コマンドの作成
  #--------------------------------------------------------------------------
  def add_each_command(command_id, enabled)
    case command_id
    when 1
      enabled = main_commands_enabled && enabled
      add_command(Vocab::item,   :item,   enabled)
    when 2
      enabled = main_commands_enabled && enabled        
      add_command(Vocab::skill,  :skill,  enabled)
    when 3
      enabled = main_commands_enabled && enabled
      add_command(Vocab::equip,  :equip,  enabled)
    when 4
      enabled = main_commands_enabled && enabled
      add_command(Vocab::status, :status, enabled)
    when 5
      enabled = formation_enabled && enabled
      add_command(Vocab::formation, :formation, enabled)
    when 6
      enabled = save_enabled && enabled
      add_command(Vocab::save, :save, enabled)
    when 7
      add_command(Vocab::game_end, :game_end, enabled)
    when 11
      add_command(Vocab::ItemDic, :item_dic, enabled)
    when 12
      add_command(Vocab::MonsDic, :mons_dic, enabled)
    when 13
      add_command(Vocab::MembChan, :memb_chan, enabled)
    when 14
      add_command(Vocab::ItemSyn, :item_syn, enabled)        
    when 15
      add_command(Vocab::SpDev, :sp_dev, enabled)
    end    
  end
end
