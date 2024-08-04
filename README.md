# QBCore Voting Script 🗳️

This script allows players to cast votes for their favorite individual between "Person 1" and "Person 2" (configurable) using the QBCore framework. Votes are securely recorded in a database to ensure persistence, and players can only vote once.

## Features ✨

- Vote for "Person 1" or "Person 2" using a context menu.
- Votes are stored and updated in a database.
- Prevent players from voting more than once.
- Display current vote counts to players.

## Installation ⚙️

1. **Download and Extract** 📥
   - Download the script, remove the main from the end, and extract it to your `resources` folder.

2. **Add to Server Config** 🛠️
   - Add the resource to your `server.cfg`:
     ```plaintext
     ensure qb-vote
     ```

3. **Configure Database** 🗃️
   - Ensure your server is set up to use `oxmysql`.
   - Execute the following SQL script to create the necessary table:
     ```sql
     CREATE TABLE votes (
         id INT AUTO_INCREMENT PRIMARY KEY,
         citizenid VARCHAR(50),
         option VARCHAR(50),
         timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     );
     ```

## Usage 🚀

- Players can vote for "Person 1" or "Person 2" using a context menu.
- Visit the coordinates specified in `config.lua` to view the current voting results.

## Credits 🏆

- Made by [Zartoz](https://github.com/Zartoz)

## Configuration ⚙️

- The script supports both `qb-menu` and `ox_lib` for context menus.
- Configure the menu library and target library in the `Config` table to suit your setup.

## Customization 🎨

- To customize the voting options or menu, edit the client and server scripts accordingly.
- Ensure the target locations (`Config.VotingLocation` and `Config.CheckVotesLocation`) are correctly set in your configuration.
