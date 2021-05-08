Group of missions aroud a "Book of Potions"
===========================================

This group of missions is meant to introduce:
- some text-processing commands including `cat`, `head` and `tail`,
- the use of the pipe `|` to combine commands.

Other mission ideas
-------------------

- Read steps 4 to 7 of some recipe.
  - Solution: `head ... | tail ...`.
  - Issue: arguably a bit artificial.
- How many steps does the transformation potion have?
  - Solution: `cat Book_of_potions/page_0[12] | tail -n +4 | wc -l`
  - Issue: a bit artificial since you can read that info in the file.
- Print steps with numbers for a recipe where step numbers are not given.
  - Solution: `tail -n+4 ... | nl -s') '`
  - Issue: there is currently no recipe without step numers in the book.
- Some steps have been missnumbered in a recipe, print a fixed version.
  - Solution: `tail -n +4 Book_of_potions/page_12 | cut -d ' ' -f 2- | nl -w1 -s ") "`
  - Issue: currently all recipe are correctly numbered in the book.
- Reattach the pages that were torn off using `paste`.
  - Solution: `paste Book_of_potions/page_06 somewhere/in/the/mountain/flying_page`
  - Issue: how do we write the result ot the book? (use `sponge`?)
- Mission with `sed` to correct an errors in the book.
  - Advantage: we can use the `-i` option to do inplace updates.
- Mission with `grep` and `wc` to count the number of recipes using some ingredient.
  - Solution: `grep ingredient page* | grep "sauge" | wc -l`
  - Issue: we'd need a line "ingredients: ..." for all recipes.
