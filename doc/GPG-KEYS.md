## Configure GPG key if they are requried
- Install https://gpgtools.org/ 
- Generate a new key
- Copy the public key  
<img src="img/CleanShot 2024-05-16 at 10.53.20@2x.png" alt="Copy key id" align="center" width="800"/>

- Paste the public key in Github settings  
<img src="img/CleanShot 2024-05-16 at 10.54.31@2x.png" alt="Copy key id" align="center" width="800"/>

- Copy key id  
<img src="img/CleanShot 2024-05-16 at 10.56.53@2x.png" alt="Copy key id" align="center" width="800"/>

- `git config --global  user.signingkey <key id> `  
- `git config --global commit.gpgsign true`

Do not delete expireted keys. Commits signed with deleted keys will be marked as unverified.  


### If using visual git clients
#### GitKraken
<img src="img/CleanShot-2025-01-09-14.53.57.png" alt="Copy key id" align="center" width="800"/>
