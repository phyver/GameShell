Pipe basics (Work in progress)
==============================

This group of missions is meant to introduce the player to the composition of
commands using the pipe (i.e., `|`).

Mission ideas:
- How many steps in the recipe for the stew?
  Solution: `tail -n +4 Book_of_potions/page_12 | wc - l`
- Read steps 4 to 7 of some recipe.
  Solution: `head ... | tail ...`.
  A bit artificial, but why not?
- And how many steps for the transformation potion?
  Solution: `cat Book_of_potions/page_0[12] | tail -n +4 | wc -l`
- The clerk was sloppy and forgot to number the steps.
  Can you show the numbered steps for SOMETHING (without the title)?
  Solution: `tail -n+4 ... | nl -s') '`
- Some steps have been missnumbered in a recipe, print a fixed version.
  Solution: `tail -n +4 Book_of_potions/page_12 | cut -d ' ' -f 2- | nl -w1 -s ") "`
- Reattach the pages that were torn off using `paste`.
  Solution: `paste Book_of_Potions/page_06 somewhere/in/the/mountain/flying_page`
  How to we write it to the book? (Cannot just redirect stdout.)
  We could use `sponge`, but not sure if we want requiring that command is an option.
- Mission with `sed` to correct an errors in the book.
  Advantage: we can use the `-i` option to do inplace updates.
- Mission with `grep` and `wc` to count the number of recipes using some ingredient.
  Problem: we'd need a line "ingredients: ..." for all recipes.
  Solution: `grep ingredient page* | grep "sauge" | wc -l`

Ideas we ruled out:
- Large combination: put together a combined list of ingredients for the healing potion.
  Solution: `tail +4 Book_of_Potions/page_11 | cat Book_of_Potions/page_10 - | tail +4 | cat Book_of_Potions/page_08 Book_of_Potions/page_09 - | tail +10  | cut -d ' ' -f 2- | nl`.
- Deciphering a recipe with `tr`.
  (Duplicates of mission 35, let's keep 35 since it is not bad.)
