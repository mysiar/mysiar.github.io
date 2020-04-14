---
title:  "Mercure - part 2 - JWT"
date:   2020-04-12 14:05
categories: DEV
tags: api mercure
---

**At the beginning a little errata to  [part 1](https://mysiar.github.io/dev/2020/04/12/mercure-part1.html){:target="_blank"}**  
We used before as JWT_KEY a certificate.  
I found a problem to generate working JWT token.  
If somebody make it working please let me know.

New files:
 * [mercure.yaml](/data/2020-04-14/mercure.yaml){:target="_blank"}
 * [mercure.service](/data/2020-04-14/mercure.service){:target="_blank"}

1. [Lets generate 256-bit key (JWT_KEY)](https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx){:target="_blank"} and use this key in [our mercure.yaml config file](/data/2020-04-14/mercure.yaml){:target="_blank"}
2. Next step would be to generate JWT_TOKEN at [jwt.io](https://jwt.io/){:target="_blank"} with below params
   * **header** - this is default for mercure (you can use different but it requires specific configuration)
     ```json
       {
          "alg": "HS256",
          "typ": "JWT"
        }
     ```
   * **payload**
     ```json
       {
          "mercure": {
            "publish": []
          }
       }
     ```
   * **your-256-bit-secret** - use the ***JWT_KEY*** generated before
   * copy and keep generated token from left top window called **Encoded**

3. replace previous file `/etc/mercure/mercure.yaml` with new one and update it with JWT_KEY generated above
4. replace previous file `/etc/systemd/system/mercure.service` with the new one and run
   * `sudo systemctl daemon-reload`
   * `sudo systemctl restart mercure.service`
5. now you have mercure server working :wink: again but this time we shall be able to talk to it
6. simple test to check if everything is OK [test-rocks.sh](/data/2020-04-14/test-rocks.sh){:target="_blank"} just replace ***JWT_TOKEN*** with your token, when you run it in console you will see returned UUID.  
  If you want to see it on web browser use [](/data/2020-04-14/mercure.html){:target="_blank"} - and check results in broser and browser console.

If you see at any stage ***Unauthorized*** that means there is something wrong :disappointed: and I think you should restart the fight :muscle:  
What doesn't kill you makes you stronger. Don't give up. :fist:

In the next part I think to do a chat app (don't know when yet). Stay tuned.
