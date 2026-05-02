# **Fiche**
[[lab2.pdf|📄 View Fiche PDF]]

## **Solution**

### **Exo 1**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<books>
    <book isbn="1">
        <title>Book 1</title>
        <year>2026</year>
        <authors>
            <author id="1">
                <name>Ali</name>
                <email>Ali@test.com</email>
            </author>
            <author id="2">
                <name>Ahmed</name>
                <email>Ahmed@test.com</email>
            </author>
        </authors>
        <chapters>
            <chapter>
                <section>sec 1</section>
                <section>sec 2</section>
                <section>sec 3</section>
            </chapter>
            <chapter>
                <section>sec 1</section>
                <section>sec 2</section>
                <section>sec 3</section>
            </chapter>
            <chapter>
                <section>sec 1</section>
                <section>sec 2</section>
                <section>sec 3</section>
            </chapter>
        </chapters>
    </book>
    <book isbn="2">
        <title>Book 1</title>
        <year>2026</year>
        <authors>
            <author id="1">
                <name>Ali</name>
                <email>Ali@test.com</email>
            </author>
            <author id="2">
                <name>Ahmed</name>
                <email>Ahmed@test.com</email>
            </author>
        </authors>
        <chapters>
            <chapter>
                <section>sec 1</section>
                <section>sec 2</section>
                <section>sec 3</section>
            </chapter>
            <chapter>
                <section>sec 1</section>
                <section>sec 2</section>
                <section>sec 3</section>
            </chapter>
            <chapter>
                <section>sec 1</section>
                <section>sec 2</section>
                <section>sec 3</section>
            </chapter>
        </chapters>
    </book>
</books>
```

### **Exo 2**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<hospital>
    <services>
        <service id="1">
            <name>service 1</name>
            <doctors>
                <doctor id="1">
                    <name>Ali</name>
                    <specialty>sp 1</specialty>
                </doctor>
                <doctor id="2">
                    <name>Ahmed</name>
                    <specialty>sp 2</specialty>
                </doctor>
                <doctor id="3">
                    <name>Mohammed</name>
                    <specialty>sp 3</specialty>
                </doctor>
            </doctors>
        </service>
        <service id="2">
            <name>service 2</name>
            <doctors>
                <doctor id="1">
                    <name>Ali</name>
                    <specialty>sp 1</specialty>
                </doctor>
                <doctor id="2">
                    <name>Ahmed</name>
                    <specialty>sp 2</specialty>
                </doctor>
                <doctor id="3">
                    <name>Mohammed</name>
                    <specialty>sp 3</specialty>
                </doctor>
            </doctors>
        </service>
        <service id="3">
            <name>service 1</name>
            <doctors>
                <doctor id="1">
                    <name>Ali</name>
                    <specialty>sp 1</specialty>
                </doctor>
                <doctor id="2">
                    <name>Ahmed</name>
                    <specialty>sp 2</specialty>
                </doctor>
                <doctor id="3">
                    <name>Mohammed</name>
                    <specialty>sp 3</specialty>
                </doctor>
            </doctors>
        </service>
    </services>
</hospital>
```

### **Exo 3**

```xml
<?xml version="1.0" encoding="UTF-8"?>

<inbox>
    <sent>
        <message id="1">
            <date>02/26/2026</date>
            <sender>Ali</sender>
            <receiver>Ahmed</receiver>
            <subject>sbj 1</subject>
            <content>cont 1</content>
        </message>
        <message id="2">
            <date>02/26/2026</date>
            <sender>Ali</sender>
            <receiver>Ahmed</receiver>
            <subject>sbj 1</subject>
            <content>cont 1</content>
        </message>
        <message id="3">
            <date>02/26/2026</date>
            <sender>Ali</sender>
            <receiver>Ahmed</receiver>
            <subject>sbj 1</subject>
            <content>cont 1</content>
        </message>
    </sent>
    <received>
        <message id="1">
            <date>02/26/2026</date>
            <sender>Ali</sender>
            <receiver>Ahmed</receiver>
            <subject>sbj 1</subject>
            <content>cont 1</content>
        </message>
        <message id="2">
            <date>02/26/2026</date>
            <sender>Ali</sender>
            <receiver>Ahmed</receiver>
            <subject>sbj 1</subject>
            <content>cont 1</content>
        </message>
        <message id="3">
            <date>02/26/2026</date>
            <sender>Ali</sender>
            <receiver>Ahmed</receiver>
            <subject>sbj 1</subject>
            <content>cont 1</content>
        </message>
    </received>
</inbox>
```
