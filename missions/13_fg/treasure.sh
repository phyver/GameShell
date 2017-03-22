#!/bin/bash

# fichier ajouté au shell courant en cas de succès de la mission

export PS1='\n\w\n[mission $(_get_current_mission)] $([ \j -gt 0 ] && echo "<\j>")$ '

