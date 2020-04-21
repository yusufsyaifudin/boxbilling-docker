# BOXBILLING DOCKER

When developing BoxBilling, you may have a problem with outdated PHP version. There, Docker come to rescue!

Clone this repo, then just download the latest version of BoxBilling from release page https://github.com/boxbilling/boxbilling/releases, for example version 4.21 https://github.com/boxbilling/boxbilling/archive/4.21.zip. Then extract to folder `srv` in this directory.

After that, run this command to download Composer package:

```
docker-compose run boxbilling bash -c "composer install -d /app/src"
```

Then, run `docker-compose up`. Voila!, you can access BoxBilling in http://localhost:8000
