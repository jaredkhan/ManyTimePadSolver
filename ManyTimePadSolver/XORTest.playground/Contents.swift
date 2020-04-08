let plaintexts = [
    "The secret recipe is: Flour, Water, MSG",
    "Please don't tell anyone the following secret",
    "The secret password is 1234",
    "Nobody should see this message",
    "I am going to tell you something very important"
]

dump(XORUtil.encryptAll(plaintexts, with: "5e3ecd6fdde3bfd9ba037a5bd819537c7cba92b56b2b0a01d6"))
