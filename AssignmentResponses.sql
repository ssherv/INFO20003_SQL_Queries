-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\_____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////____/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\_____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\____/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////____\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\___________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\____________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\______________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///_________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Shervyn Singh
-- Your Student Number: 1236509
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

SELECT COUNT(*) AS speciesCount
FROM Species
WHERE description LIKE '%this %';

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

SELECT Player.username, SUM(Phonemon.power) AS totalPhonemonPower
FROM Player INNER JOIN Phonemon ON Player.id = Phonemon.player
WHERE Player.username IN ('Cook', 'Hughes')
GROUP BY Player.username;

-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

SELECT Team.title, COUNT(*) AS numberOfPlayers
FROM Team INNER JOIN Player ON Team.id = Player.team
GROUP BY Team.title
ORDER BY numberOfPlayers DESC;

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4

SELECT id AS idSpecies, title
FROM Species 
WHERE type1 = (SELECT id FROM Type WHERE title = 'Grass') OR type2 = (SELECT id FROM Type WHERE title = 'Grass');

-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5

SELECT DISTINCT Player.id AS idPlayer, Player.username
FROM Player LEFT OUTER JOIN Purchase ON Player.id = Purchase.player
WHERE Player.id NOT IN 
	(SELECT DISTINCT player FROM Purchase WHERE item IN (SELECT id FROM Food));

-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6

SELECT level, SUM(TotalSpent) AS totalAmountSpentByAllPlayersAtLevel
FROM 
	(SELECT Player.id, Player.username, Player.level, Item.id AS idItem, Item.price, Purchase.quantity, (Item.price * Purchase.quantity) AS TotalSpent
		FROM Player 
		INNER JOIN Purchase ON Player.id = Purchase.player 
		INNER JOIN Item ON Purchase.item = Item.id
	ORDER BY Player.id) AS PlayerPurchases
GROUP BY level
ORDER BY SUM(TotalSpent) DESC;

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7

SELECT Item.id AS item, Item.title, SUM(Purchase.quantity) AS numTimesPurchased
FROM Item INNER JOIN Purchase ON Item.id = Purchase.item
GROUP BY Item.id
HAVING numTimesPurchased = (Select SUM(Quantity) FROM Purchase GROUP BY Item ORDER BY SUM(Quantity) DESC LIMIT 1);

-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

SELECT playerID, username, COUNT(DISTINCT foodID) AS numberDistinctFoodItemsPurchased
FROM
	(SELECT Player.id AS playerID, Player.username, Food.id AS foodID
		FROM Player 
		INNER JOIN Purchase ON Player.id = Purchase.player
		INNER JOIN Food ON Purchase.item = Food.id) AS FoodPurchasors
GROUP BY playerID
HAVING numberDistinctFoodItemsPurchased = (SELECT COUNT(id) FROM Food);

-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9

SELECT COUNT(*) AS numberOfPhonemonPairs, distanceX
FROM
	(SELECT P1.id AS phonemon1,  P2.id AS phonemon2, ROUND((SQRT(POWER((P1.latitude - P2.latitude), 2) + POWER((P1.longitude - P2.longitude), 2))) * 100 ,2) AS distanceX
	FROM (Phonemon AS P1 CROSS JOIN Phonemon AS P2)
	WHERE P1.id < P2.id) AS distanceBetweenPhonemons
GROUP BY distanceX
ORDER BY distanceX ASC
LIMIT 1;

-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10

SELECT username, typeTitle AS title
FROM
	(SELECT Player.id, Player.username, typeID, typeTitle, COUNT(DISTINCT SpeciesID) AS speciesOwnedPerType, totalSpeciesPerType
	FROM Player
		INNER JOIN Phonemon ON Player.id = Phonemon.player
		INNER JOIN ((SELECT Species.id AS speciesID, Species.title AS speciesName, Type.id AS typeID, Type.title AS typeTitle FROM Species INNER JOIN Type ON Species.type1 = Type.id)  
					UNION   
					(SELECT Species.id, Species.title, Type.id, Type.title FROM Species INNER JOIN Type ON Species.type2 = Type.id)) AS allPhonemonVariants ON Phonemon.species = speciesID
		INNER JOIN (SELECT IDtype, COUNT(*) AS totalSpeciesPerType FROM
				((SELECT Species.id, Species.type1 AS IDtype FROM Species INNER JOIN Type ON Species.type1 = Type.id)   
                UNION   
                (SELECT Species.id, Species.type2 AS IDtype FROM Species INNER JOIN Type ON Species.type2 = Type.id)) AS countAllSpeciesTypes
				GROUP BY IDtype) AS countTypes ON typeID = IDtype
	GROUP BY Player.id, Player.username, typeID, typeTitle) AS compareCounts
WHERE speciesOwnedPerType = totalSpeciesPerType;

-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line