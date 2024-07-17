echo "ENTER THE DOMAIN:"
read domain
assetfinder $domain | httpx -silent | sed -s 's/$/\//' | xargs -I@ sh -c 'x8 -u @ -w params.txt -o enumerate'
