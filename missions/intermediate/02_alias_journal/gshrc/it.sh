# Questo file è caricato (o 'sourced' in shell jargon) quando il gioco
# si avvia. Puoi usarlo per registrare alias (e altre cose)
# che desideri mantenere tra le varie sessioni di gioco.
# Infatti, un alias definito nella shell sarà "dimenticato" se
# non verrà aggiunto qui (gli alias definiti come parte delle missioni
# sono memorizzati per te).
#
# Nota bene: tutte le linee che cominciano con '#' in questo file
# sono ignorate. La shell standard utilizza questi file, di solito
# nascosti nella home. Per bash il file si trova al percorso
#       ~/.bashrc
# e per zsh si trova
#       ~/.zshrc
# (Non modificare questi file perchè sono utilizzati da GameShell!) 

# Ogni volta che modifichi questo file, le definizioni che contengono
# non vengono aggiunte direttamente nella shell corrente. Si può fare
# affidamento al seguente alias per farlo.
alias reload="source ~/.gshrc"

# Qui ci sono alcune idee di alias per te:
# -l'alias "gg" per "gsh goal",
# -l'alias "gc" per "gsh check",
# -l'alias "editrc" per modificare questo file con nano.
