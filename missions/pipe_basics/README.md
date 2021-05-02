Pipe basics (Work in progress)
==============================

This group of missions is meant to introduce the player to the composition of
commands using the pipe (i.e., `|`).

Plan for hte missions:
1. Intro to `head`: show the recipy of herbal tea (followed by another recipe
   on the same page). Solution: `head -n 6 Book_of_Potions/page_07`.
2. Intro to `tail`: show the recipe steps for toadstool soup (not the title).
   Solution: `tail -n 9 Book_of_Potions/page_12`.
3. Use of `cat`: show the full recipe for the transformation potion (on two
   pages). Solution: `cat Book_of_Potions/page_01 Book_of_Potions/page_02`
4. Intro of the pipe: show the recipe steps for the elixir of youth (without
   the title. Solution: `cat Book_of_Potions/page_03 Book_of_Potions/page_04 | tail -n 16`
5. How many lines does the book have? Solution `cat Book_of_Potions/* | wc -l`
6. ...
7. ...
8. Large combination: put together a combined list of ingredients for the
   healing potion. Solution: `tail +4 Book_of_Potions/page_11 | cat Book_of_Potions/page_10 - | tail +4 | cat Book_of_Potions/page_08 Book_of_Potions/page_09 - | tail +10  | cut -d ' ' -f 2- | nl`.


Other ideas:
- Ask the player to find a page that got lost (taken by the wind).
