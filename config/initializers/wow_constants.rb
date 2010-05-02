BOSSES = YAML.load_file("#{RAILS_ROOT}/config/bosses.yml")
CLASSES = YAML.load_file("#{RAILS_ROOT}/config/classes.yml")

OBJECT_TYPE_MASK = 0x0000FC00						# 64512
OBJECT_TYPE_OBJECT = 0x00004000					# 16384
OBJECT_TYPE_GUARDIAN = 0x00002000				# 8192
OBJECT_TYPE_PET = 0x00001000						# 4096
OBJECT_TYPE_NPC = 0x00000800						# 2048
OBJECT_TYPE_PLAYER = 0x00000400					# 1024
OBJECT_CONTROL_MASK = 0x00000300
OBJECT_CONTROL_NPC = 0x00000200					# 512
OBJECT_CONTROL_PLAYER = 0x00000100			# 256
OBJECT_REACTION_MASK = 0x000000F0
OBJECT_REACTION_HOSTILE = 0x00000040		# 64
OBJECT_REACTION_NEUTRAL = 0x00000020		# 32
OBJECT_REACTION_FRIENDLY = 0x00000010		# 16
OBJECT_AFFILIATION_MASK = 0x0000000F
OBJECT_AFFILIATION_OUTSIDER = 0x00000008
OBJECT_AFFILIATION_RAID = 0x00000004
OBJECT_AFFILIATION_PARTY = 0x00000002
OBJECT_AFFILIATION_MINE = 0x00000001
OBJECT_SPECIAL_MASK = 0xFFFF0000
OBJECT_NONE = 0x80000000
OBJECT_RAIDTARGET8 = 0x08000000
OBJECT_RAIDTARGET7 = 0x04000000
OBJECT_RAIDTARGET6 = 0x02000000
OBJECT_RAIDTARGET5 = 0x01000000
OBJECT_RAIDTARGET4 = 0x00800000
OBJECT_RAIDTARGET3 = 0x00400000
OBJECT_RAIDTARGET2 = 0x00200000
OBJECT_RAIDTARGET1 = 0x00100000
OBJECT_MAINASSIST = 0x00080000
OBJECT_MAINTANK = 0x00040000
OBJECT_FOCUS = 0x00020000
OBJECT_TARGET = 0x00010000

UNIT_GUID_NONE = 0x0000000000000000

SCHOOL_NONE = 0x0
SCHOOL_PHYSICAL = 0x01
SCHOOL_HOLY = 0x02
SCHOOL_FIRE = 0x04
SCHOOL_NATURE = 0x08
SCHOOL_FIRESTORM = 0xC
SCHOOL_FROST = 0x10
SCHOOL_FROSTFIRE = 0x14
SCHOOL_FROSTSTORM = 0x18
SCHOOL_SHADOW = 0x20
SCHOOL_SHADOWSTORM = 0x28
SCHOOL_SHADOWFROST = 0x30
SCHOOL_ARCANE = 0x40
SCHOOL_SPELLFIRE = 0x44

RESULT_NONE = 0x0
RESULT_SUCCESS = 0x01
RESULT_FAILURE = 0x02

CLASS_DEATHKNIGHT = 6
CLASS_DRUID = 11
CLASS_HUNTER = 3
CLASS_MAGE = 8
CLASS_PALADIN = 2
CLASS_PRIEST = 5
CLASS_ROGUE = 4
CLASS_SHAMAN = 7
CLASS_WARLOCK = 9
CLASS_WARRIOR = 1

AURA_NONE = 0x0
AURA_BUFF = 0x01
AURA_DEBUFF = 0x02

POWER_NONE = -10
POWER_HEALTH = -2
POWER_MANA = 0
POWER_RAGE = 1
POWER_FOCUS = 2
POWER_ENERGY = 3
POWER_HAPPINESS = 4
POWER_RUNES = 5
POWER_RUNIC = 6