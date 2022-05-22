## First Time Setup
1. Clone this repository to your local drive

    ```>> git clone https://github.com/FickleHobbyist/aero-db-demo.git [destination]```

### Windows
2. Open a command prompt **_as administrator_** and navigate to your `[destination]`
3. Create a new virtual environment using Python 3.8 (you may need to use the `python3` command depending on your 
   path settings. I am using `python` because I only have Python 3.8 installed).

    ```>> python -m venv .\venv```
4. Activate the virtual environment

    ```>> .\venv\Scripts\activate.bat```
5. You should now see `(venv)` prepended to the directory in your command prompt.
6. Update pip

    ```>> python -m pip install --upgrade pip```
7. Install requirements as listed in `requirements.txt`

    ```>> pip install -r requirements.txt```

# References
1. [Django Tutorial](https://docs.djangoproject.com/en/4.0/intro/tutorial02/)
    * Left off at [Creating models](https://docs.djangoproject.com/en/4.0/intro/tutorial02/#creating-models-1) 2022-05-21
1. [Markdown Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
1. [Django ORM vs SQLAlchemy](https://ebs-integrator.com/blog/django-orm-vs-sql-alchemy/#:~:text=Differences%20%E2%80%93%20SQL%20Alchemy%20vs%20Django,with%20the%20overall%20model%20object.)
1. [Generating requirements.txt](https://stackoverflow.com/questions/31684375/automatically-create-requirements-txt)
