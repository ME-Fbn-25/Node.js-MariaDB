/*
+-------------------------------+
| Ingredient_Classes            |
+-------------------------------+
| IngredientClassID          PK |
| IngredientClassDescription    |
+-------------------------------+

+----------------------+
| Ingredients          |
+----------------------+
| IngredientID      PK |
| IngredientName       |
| IngredientClassID FK |
| MeasureAmountID   FK |
+----------------------+

+---------------------+
| Recipe_Ingredients  |
+---------------------+
| RecipeID        CPK |
| RecipeSeqNo     CPK |
| IngredientID    FK  |
| MeasureAmountID FK  |
| Amount              |
+---------------------+

+------------------+
| Recipes          |
+------------------+
| RecipeID      PK |
| RecipeTitle      |
| RecipeClassID FK |
| Preparation      |
| Notes            |
+------------------+
*/

-- List all recipes that have a seafood ingredient.

SELECT RecipeTitle FROM Recipes r
JOIN Recipe_Ingredients ri ON ri.RecipeID = r.RecipeID
JOIN Ingredients i ON i.IngredientID = ri.RecipeID
JOIN Ingredient_Classes ic ON ic.IngredientClassID = i.IngredientID
WHERE IngredientClassDescription = 'seafood';

SELECT * FROM Recipes
WHERE RecipeID IN (SELECT RecipeID FROM Recipe_Ingredients WHERE IngredientINT IN (
  SELECT IngredientID FROM Ingredients WHERE IngredientCLassID IN (
    SELECT IngredientCLassID FROM Ingredient_Classes WHERE IngredientClassDescription = 'seafood'
  )
));



-- Show me the recpies that have beef or garlic.
SELECT RecipeTitle FROM Recipes r
JOIN Recipe_Ingredients ri ON ri.RecipeID = r.RecipeID
JOIN Ingredients i ON i.IngredientID = ri.RecipeID
WHERE IngredientName IN ('beef', 'garlic');





/*
+------------------------+
| Categories             |
+------------------------+
| CategoryID          PK |
| CategoryDescription    |
+------------------------+

+-----------------------+
| Products              |
+-----------------------+
| ProductNumber      PK |
| ProductName           |
| ProductDescription    |
| RetailPrice           |
| QuantityOnHand        |
| CategoryID         FK |
+-----------------------+
*/


-- Find all accessories that are priced greater than any clothing item.