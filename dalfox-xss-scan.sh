echo "ENTER THE DOMAIN NAME:"

read domain

echo $domain | subfinder -silent | anew | httpx -silent -threads 500 | xargs -I@ dalfox url @

