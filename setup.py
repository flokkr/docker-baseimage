from setuptools import setup

setup(name='configuration',
      version='0.1',
      description='Configuration retriever',
      url='http://github.com/elek/bigdata-base',
      author='Elek, Marton',
      author_email='elek@noreply.github.com',
      license='APACHE',
      packages=['configuration'],
      entry_points={
          'console_scripts': [
              'simple=configuration.simple:main',
              'consul_starter=configuration.consul_starter:main'
          ]
      },
      install_requires=[
          'python-consul',
          'jinja2'
      ])
