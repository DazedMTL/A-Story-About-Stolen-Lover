#==============================================================================
# ■ Vocab
#------------------------------------------------------------------------------
# 　用語とメッセージを定義するモジュールです。定数でメッセージなどを直接定義す
# るほか、グローバル変数 $data_system から用語データを取得します。
#==============================================================================

module Vocab

  # Shop Screen
  ShopBuy         = "Buy"
  ShopSell        = "Sell"
  ShopCancel      = "Cancel"
  Possession      = "Amount Owned"

  # Status Screen
  ExpTotal        = "Current Exp"
  ExpNext         = "To Next %s"

  # Save/Load Screen
  SaveMessage     = "Which file would you like to save to?"
  LoadMessage     = "Which file would you like to load?"
  File            = "File"

  # Display for multiple members
  PartyName       = "%s and others"

  # Basic Battle Messages
  Emerge          = "%s appeared!"
  Preemptive      = "%s took the initiative!"
  Surprise        = "%s is caught by surprise!"
  EscapeStart     = "%s started to flee!"
  EscapeFailure   = "But escaping was not possible!"

  # Battle End Messages
  Victory         = "Victory for %s!"
  Defeat          = "%s is defeated in battle."
  ObtainExp       = "Gained %s exp!"
  ObtainGold      = "Obtained %s\\G of money!"
  ObtainItem      = "Obtained %s!"
  LevelUp         = "%s has leveled up to %s %s!"
  ObtainSkill     = "Learned %s!"

  # Item Use
  UseItem         = "%s used %s!"

  # Critical Hit
  CriticalToEnemy = "A critical hit!!"
  CriticalToActor = "A grievous hit!!"

  # Action Result for Actors
  ActorDamage     = "%s took %s damage!"
  ActorRecovery   = "%s's %s recovered by %s!"
  ActorGain       = "%s's %s increased by %s!"
  ActorLoss       = "%s's %s decreased by %s!"
  ActorDrain      = "%s had %s drained by %s!"
  ActorNoDamage   = "%s took no damage!"
  ActorNoHit      = "Miss! %s took no damage!"

  # Action Result for Enemy Characters
  EnemyDamage     = "Dealt %s damage to %s!"
  EnemyRecovery   = "%s's %s recovered by %s!"
  EnemyGain       = "%s's %s increased by %s!"
  EnemyLoss       = "%s's %s decreased by %s!"
  EnemyDrain      = "Drained %s of %s by %s!"
  EnemyNoDamage   = "No damage dealt to %s!"
  EnemyNoHit      = "Miss! No damage dealt to %s!"

  # Evasion/Reflection
  Evasion         = "%s dodged the attack!"
  MagicEvasion    = "%s nullified the magic!"
  MagicReflection = "%s reflected the magic!"
  CounterAttack   = "Counterattack by %s!"
  Substitute      = "%s covered for %s!"

  # Buff/Debuff
  BuffAdd         = "%s's %s increased!"
  DebuffAdd       = "%s's %s decreased!"
  BuffRemove      = "%s's %s returned to normal!"

  # Skill, Item had no effect
  ActionFailure   = "It had no effect on %s!"

  # Error Messages
  PlayerPosError  = "The player's initial position is not set."
  EventOverflow   = "The call to the Common Event has exceeded the limit."

  # 基本ステータス
  def self.basic(basic_id)
    $data_system.terms.basic[basic_id]
  end

  # 能力値
  def self.param(param_id)
    $data_system.terms.params[param_id]
  end

  # 装備タイプ
  def self.etype(etype_id)
    $data_system.terms.etypes[etype_id]
  end

  # コマンド
  def self.command(command_id)
    $data_system.terms.commands[command_id]
  end

  # 通貨単位
  def self.currency_unit
    $data_system.currency_unit
  end

  #--------------------------------------------------------------------------
  def self.level;       basic(0);     end   # レベル
  def self.level_a;     basic(1);     end   # レベル (短)
  def self.hp;          basic(2);     end   # HP
  def self.hp_a;        basic(3);     end   # HP (短)
  def self.mp;          basic(4);     end   # MP
  def self.mp_a;        basic(5);     end   # MP (短)
  def self.tp;          basic(6);     end   # TP
  def self.tp_a;        basic(7);     end   # TP (短)
  def self.fight;       command(0);   end   # 戦う
  def self.escape;      command(1);   end   # 逃げる
  def self.attack;      command(2);   end   # 攻撃
  def self.guard;       command(3);   end   # 防御
  def self.item;        command(4);   end   # アイテム
  def self.skill;       command(5);   end   # スキル
  def self.equip;       command(6);   end   # 装備
  def self.status;      command(7);   end   # ステータス
  def self.formation;   command(8);   end   # 並び替え
  def self.save;        command(9);   end   # セーブ
  def self.game_end;    command(10);  end   # ゲーム終了
  def self.weapon;      command(12);  end   # 武器
  def self.armor;       command(13);  end   # 防具
  def self.key_item;    command(14);  end   # 大事なもの
  def self.equip2;      command(15);  end   # 装備変更
  def self.optimize;    command(16);  end   # 最強装備
  def self.clear;       command(17);  end   # 全て外す
  def self.new_game;    command(18);  end   # ニューゲーム
  def self.continue;    command(19);  end   # コンティニュー
  def self.shutdown;    command(20);  end   # シャットダウン
  def self.to_title;    command(21);  end   # タイトルへ
  def self.cancel;      command(22);  end   # やめる
  #--------------------------------------------------------------------------
end
