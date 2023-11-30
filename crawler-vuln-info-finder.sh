#About
#Take a list of domains, crawl urls and scan for endpoints, secrets, api keys, file extensions, tokens and more

'''
ENTER THE DOMAIN YOU WANT TO DO RECON ON
'''

echo "HERE:"

read domain

echo $domain | subfinder -silent | httpx -silent | cariddi -intensive
