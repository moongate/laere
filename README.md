# DISCLAIMER

Hi! This project was my "Course Completion Assignment" ("Projeto Final", in portuguese)
for my Bachelor of Information Systems at PUC-Rio.
The idea was to create an open source LMS (learning management system) focused in teaching programming.
We aimed to deliver a free online learning platform and all the tools to host your private copy.
In the platform, anyone would be able to create their own courses from existing online material.
One of the main motivators was "Flip Education", the idea that in-person mentorship should complement
a self-guided, self-paced online learning experience.

The project was worthwhile as an exercise in building a working CRUD app with the [MEAN stack](http://mean.io/#!/) and
in investigating teaching methodologies. It was, unfortunately, never "finished" (is there such a thing? ;).
You're welcome to browse and use the code as you wish, but frankly it's quite dated by now.
You can also [read the paper](https://goo.gl/XdBjNq) that complements this project (only available in portuguese).

Special kudos for @rodrigomuniz who joined me for this short-lived but very fun adventure.
He was instrumental designing the product with an user-first approach. Thanks!

# Laere

### The online classroom engine

[![Build Status](https://travis-ci.org/moongate/laere.png)](https://travis-ci.org/moongate/laere)

The best way to organize and teach your online classrooms.

### Installing

You'll need `mongodb` running locally. See [how to install MongoDB](https://docs.mongodb.org/manual/installation/).

Then, install dependencies with `npm` and use the `start` script:

```
$ npm install
$ npm start
```

Use `mongorestore` to restore the dump present in `dump/`.

There are two initial `user:pass` combinations:
`test@laere.co:test` and `test2@laere.co:test2`.

Finally, add `laeredev.co` and `laere.laeredev.co` to your `hosts` file:

```
$ sudo vim /etc/hosts

(...)
127.0.0.1       laere.laeredev.co
127.0.0.1       laeredev.co
```

Visit `http://laere.laeredev.co:5000` and you should be good to go.
