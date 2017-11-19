from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [Extension("flint", ["src/pyflint.pyx"], libraries=["flint", "arb", "mpir", "mpfr", "pthreads"])]

for e in ext_modules:
    e.cython_directives  =  {"embedsignature":  True}

setup(
  name = 'flint',
  cmdclass = {'build_ext':build_ext},
  ext_modules = ext_modules,
  description = 'bindings for FLINT',
  version = '0.1.2',
  url='https://github.com/fredrik-johansson/python-flint',
  author='Fredrik Johansson',
  author_email='fredrik.johansson@gmail.com',
  license = 'BSD',
  classifiers=['Topic :: Scientific/Engineering :: Mathematics']
)
