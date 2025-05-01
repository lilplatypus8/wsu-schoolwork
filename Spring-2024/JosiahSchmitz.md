# Vulnerability Taxonomy CWE Homework

## Name: Josiah Schmitz

The CWE that I chose was Improper Input Validation, [CWE-20](https://cwe.mitre.org/data/definitions/20.html).
In this particular example, the mistake was in a program that is intended to take a given time in seconds, and,
using this time value, calculate the velocity of a particular object. The velocity is calculated using a CSV datalist
of LLA position values at given times, allowing me to interpolate the velocity of the object using adjacent position values
in the CSV file. However, I had nothing in place to check whether the time value was within the range of values in the CSV
file, meaning that the user could input an incredibly large value to attempt a resource consumption ([CWE-400](https://cwe.mitre.org/data/definitions/400.html))
attack.

My CPE is *cpe:2.3:a:schmitz3400:velocity_interpolator:1.5.3*. The "*cpe:2.3*" simply tells that I am using cpe formatting
based on CPE version 2.3. "*a*" shows that this is the first (and only, in this case) portion of the program. "*schmitz3400*" is
the "vendor" in this case, while "*velocity_interpolator*" is my name for the program. "*1.5.3*" is a rough estimate of what
version this program is, given that I did not use version control on this script.

CWE-20 is not only #6 in the Top 25 Most Dangerous Software Weaknesses list, it is also #4 in the top 10 KEV Weaknesses list.
This seems reasonable, given that it is a relatively easy mistake to make and very simple to exploit. I personally have unintentionally
implemented this weakness many times in my previous programs since I did not realize how easy it was to exploit it. Of course, I personally
have never experienced this weakness being exploited before. Fixing it would be a relatively simple task, as I would just have to set
reasonable parameters for what the user could input into the program, i.e. upper and lower bounds on the integer value of the input.
An example I found of this Improper Input Validation is [CVE-2024-24696](https://www.cve.org/CVERecord?id=CVE-2024-24696), where a
user could "conduct a disclosure of information via network access." The CPE with this vulnerability is *cpe:2.3:a:zoom:meeting_software_development_kit:5.16.0:*:*:*:*:*:*:**.
