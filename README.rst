========================================
 Turn Emacs into an IDE for Pythonista!
========================================

.. warning:: WORK IN PROGRESS

Emacs has various packages to enhance programming in Python.  But
setting up them separately is cumbersome.  This package aims at
providing sane default for the best practice.

Note that this package violates some Emacs conventions on purpose.
For example, key bind starts with ``C-c <ALPHABET>`` is allocated for
user configuration and any well-behaved major and minor modes do not
set keybind to it.  However, this meas you need to configure it by
yourself, which makes it hard to setup Emacs.  Pythonista.el do set
these keybind to reduce the amount of configuration for you.  At the
same time, there is a way to "undo" these configurations.
