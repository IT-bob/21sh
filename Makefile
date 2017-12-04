# Nom
NAME = 21sh
PROJET = 21sh

# Détection de l'OS
OS = $(shell uname -s)

# Options de compilation
CC = @gcc
CFLAGS = -Wall -Werror -Wextra
ifeq ($(OS), Linux)
	CFLAGSUP = -Wno-sign-compare -Wno-empty-body #-g -fsanitize=address
else
	CFLAGSUP = -Wno-sign-compare # -g -fsanitize=address
endif
CPPFLAGS = -I $(INC_PATH) -I $(LIB_INC) -I $(LINE_INC)
CLIB = -L $(LINE) -llinput -L $(LIBFT) -lft -ltermcap

# Fichiers d'en-tête
INC_PATH = project/21sh/includes/
INC_FILE = twenty_onesh.h
INC = $(addprefix $(INC_PATH), $(INC_FILE))

# Fichiers sources
SRC_PATH = project/21sh/src/
SRC_FILE = main.c set_environ.c
SRC = $(addprefix $(SRC_PATH), $(SRC_FILE))
OBJ = $(SRC:.c=.o)

# Fichiers des bibliothèques
LIBFT = project/libft/
LIB_INC = $(LIBFT)includes/
LIB = $(LIBFT)libft.a

LINE = project/line_input/
LINE_INC = $(LINE)includes/
LIBLINE = $(LINE)liblinput.a

# Règles de compilation
all: lib $(NAME)

$(NAME): Makefile $(LIB) $(LIBLINE) $(OBJ)
	@echo "$(CYAN)Compilation de $(NAME)$(RESET)"
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(CFLAGSUP) $(OBJ) $(CLIB) -o $(NAME)

$(OBJ): $(INC)

lib:
	@echo "$(VERT)Compilation...$(RESET)"
	@make -C $(LIBFT) all
	@make -C $(LINE) LIBFT_INC=../libft/includes all

clean: cleanproj
	@make -C $(LIBFT) clean
	@make -C $(LINE) clean

fclean: fcleanproj
	@make -C $(LIBFT) fclean
	@make -C $(LINE) fclean

re: fclean all

cleanproj:
	@echo "$(ROUGEC)Suppression des fichiers objets de $(NAME)$(RESET)"
	@rm -f $(OBJ)

fcleanproj: cleanproj
	@echo "$(ROUGEC)Suppression de l'exécutable $(NAME)$(RESET)"
	@rm -f $(NAME)

# Règles pour la documentation
doxygen:
	@echo "$(CYAN)Génération de la documentation de $(PROJET)$(RESET)"
	@mkdir -p Docs
	@doxygen $(PROJET).doxyconf > Docs/$(PROJET).log
	#@echo "Pas de fichier de documentation pour $(PROJET)"
	@make -C $(LIBFT) doxygen
	@make -C $(LINE) doxygen

cleandoxy:
	@echo "Suppression de la documentation de $(PROJET)"
	@rm -rf Docs/
	@make -C $(LIBFT) cleandoxy
	@make -C $(LINE) cleandoxy

fcleanall: cleandoxy fclean

# Couleurs
RESET = \033[0m
BLANC = \033[37m
BLEU  = \033[34m
CYAN  = \033[36m
JAUNE = \033[33m
MAGEN = \033[35m
NOIR  = \033[30m
ROUGE = \033[31m
ROUGEC = \033[1;31m
VERT  = \033[32m

.PHONY: all lib clean fclean re doxygen cleandoxy