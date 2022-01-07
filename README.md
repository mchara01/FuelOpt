# FuelOpt
![GitHub repo size](https://img.shields.io/github/repo-size/mchara01/FuelOpt)
![GitHub contributors](https://img.shields.io/github/contributors/mchara01/FuelOpt)
![GitHub stars](https://img.shields.io/github/stars/mchara01/FuelOpt?style=social)
![GitHub forks](https://img.shields.io/github/forks/mchara01/FuelOpt?style=social)
![example workflow](https://github.com/mchara01/FuelOpt/actions/workflows/aws.yml/badge.svg)

With the energy crisis hitting Britain in September 2021 and worries of a fuel shortage, we 
devised an app to help people avoid queues and save the environment. FuelOpt is a user-friendly,
open-source, platform-independent and socially helpful app to assist motorists in planning and optimising 
their fuel-filling journeys in terms of cost, time, and fuel efficiency. Currently, the application
focuses on the geographic area of London, UK, where the shortage was mostly felt.

## Documentation
The FuelOpt project documentation is located at [doc/api documentation](https://github.com/mchara01/FuelOpt/blob/main/doc/api%20documentation). Alternatively, you can find it here: http://18.170.63.134:8000/api-docs/

## Prerequisites

Before you begin, ensure you have met the following requirements:

* You installed of all the required Python modules with:  `pip install -r backend/requirements.txt`
* You are using Python >= 3.8.
* You have entered your API keys (e.g AWS, Google) where necessary. The config_sample.py in the backend directory illustrates how the API key should be in the config.py file you will must create. 

## Architecture
<p align="center">
  <img src="drawio/fuelopt_arch_final.jpg">
</p>

## Contributing to FuelOpt
To contribute to ***FuelOpt***, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

## Testing
To run the unit tests on our backend API methods, in the terminal:
1. cd into the FuelOpt directory: `cd FuelOpt`
2. Execute: `python ../FuelOpt/src/backend/manage.py test ../FuelOpt/test/`

## Useful links

- [Flutter documentation](https://flutter.dev/docs)
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Docker documentation](https://docs.docker.com/)

## Authors

* **Marcos-Antonios Charalambous** - *mc921@ic.ac.uk*
* **Alicia Jiayun Law** - *ajl115@ic.ac.uk*
* **Dimosthenis Tsormpatzoudis** - *dt521@ic.ac.uk*
* **Nadim Rahman** - *nr421@ic.ac.uk*
* **Dennis Duka** - *dn321@ic.ac.uk*
* **Ye Liu** - *yl10321@ic.ac.uk*
* **Maxim Fishman** - *maf221@ic.ac.uk*

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
