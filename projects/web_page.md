# Web Page

This page is a project of mine.

But it is not only my content but also my site generation.

For a reason I cannot remember and I cannot reason about I created a site generator using markdown, bash and some javascript as a cherry on top.

Well there is more to it, like pandoc and html and magic. But my part is the bash script, javascript and the markdown content.

It basically works like this.

1. I write e.g. a blog post in markdown.
2. I call `bash build.sh`
3. The script transforms the markdown content to html, adds the blog post to my menu and moves all assets into an output folder.
4. For testing I can call `python3 -m http.server` and go to `0.0.0.0:5000` to inspect my changes.

It took my way too long to write it in bash but it is a lot of joy to call the script and everything is just moved and generated. :)