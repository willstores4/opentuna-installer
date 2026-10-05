EE_BIN = Installer.elf
EE_BIN_PACKED = OpenTuna_WILL_Installer.elf
EE_BIN_STRIPPED = stripped.elf
EE_OBJS = main.o gs.o pad.o  gs_asm.o ps2_asm.o dma_asm.o
EE_OBJS += opl_elf.o ule_elf.o apps_icn.o apps_sys.o OpenTuna_sys.o OpenTuna_SLIMS.o OpenTuna_FAT-170.o OpenTuna_FAT-110-120-150-160.o PADMAN_irx.o SIO2MAN_irx.o MCMAN_irx.o MCSERV_irx.o
EE_OBJS += opl_conf_game.o opl_conf_network.o opl_conf_opl.o opl_font.o opl_icon_sys.o opl_lang.o opl_icn.o
EE_SRC =   opl_elf.s ule_elf.s apps_icn.s apps_sys.s OpenTuna_sys.s  OpenTuna_SLIMS.s OpenTuna_FAT-170.s OpenTuna_FAT-110-120-150-160.s PADMAN_irx.c SIO2MAN_irx.c MCMAN_irx.c MCSERV_irx.c
EE_SRC += opl_conf_game.s opl_conf_network.s opl_conf_opl.s opl_font.s opl_icon_sys.s opl_lang.s opl_icn.s
EE_LIBS = -ldebug -lcdvd -lpatches -lpadx -lmc

all:
	$(MAKE) $(EE_BIN_PACKED)

opl_elf.s:
	bin2s INSTALL/APPS/OPNPS2LD.ELF opl_elf.s opl_elf

ule_elf.s:
	bin2s INSTALL/APPS/ULE.ELF ule_elf.s ule_elf

opl_conf_game.s:
	bin2s INSTALL/OPL/conf_game.cfg opl_conf_game.s opl_conf_game

opl_conf_network.s:
	bin2s INSTALL/OPL/conf_network.cfg opl_conf_network.s opl_conf_network

opl_conf_opl.s:
	bin2s INSTALL/OPL/conf_opl.cfg opl_conf_opl.s opl_conf_opl

opl_font.s:
	bin2s INSTALL/OPL/font_Portuguese_BR.ttf opl_font.s opl_font

opl_icon_sys.s:
	bin2s INSTALL/OPL/icon.sys opl_icon_sys.s opl_icon_sys

opl_lang.s:
	bin2s INSTALL/OPL/lang_Portuguese_BR.lng opl_lang.s opl_lang

opl_icn.s:
	bin2s INSTALL/OPL/opl.icn opl_icn.s opl_icn

apps_icn.s:
	bin2s INSTALL/APPS/tunacan.icn apps_icn.s apps_icn

apps_sys.s:
	bin2s INSTALL/APPS/icon.sys apps_sys.s apps_sys

OpenTuna_sys.s:
	bin2s INSTALL/OPENTUNA/icon.sys OpenTuna_sys.s opentuna_sys

OpenTuna_SLIMS.s:
	bin2s INSTALL/OPENTUNA/OpenTuna_Slims.bin OpenTuna_SLIMS.s opentuna_slims

OpenTuna_FAT-110-120-150-160.s:
	bin2s INSTALL/OPENTUNA/OpenTuna_FAT-110-120-150-160.bin OpenTuna_FAT-110-120-150-160.s opentuna_fats

OpenTuna_FAT-170.s:
	bin2s INSTALL/OPENTUNA/OpenTuna_FAT-170.bin OpenTuna_FAT-170.s opentuna_fat170

SIO2MAN_irx.c: $(PS2SDK)/iop/irx/freesio2.irx
	bin2c $(PS2SDK)/iop/irx/freesio2.irx SIO2MAN_irx.c SIO2MAN_irx

MCMAN_irx.c: $(PS2SDK)/iop/irx/mcman.irx
	bin2c $(PS2SDK)/iop/irx/mcman.irx MCMAN_irx.c MCMAN_irx

MCSERV_irx.c: $(PS2SDK)/iop/irx/mcserv.irx
	bin2c $(PS2SDK)/iop/irx/mcserv.irx MCSERV_irx.c MCSERV_irx

PADMAN_irx.c: $(PS2SDK)/iop/irx/freepad.irx
	bin2c $(PS2SDK)/iop/irx/freepad.irx PADMAN_irx.c PADMAN_irx

clean:
	rm -fr $(EE_OBJS) $(EE_BIN_PACKED) $(EE_BIN_STRIPPED) $(EE_BIN) $(EE_SRC)

$(EE_BIN_STRIPPED): $(EE_BIN)
	$(EE_STRIP) -o $@ $<

$(EE_BIN_PACKED): $(EE_BIN_STRIPPED)
	ps2-packer $< $@ > /dev/null

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
