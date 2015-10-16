#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'untitled.ui'
#
# Created: Tue Jan 20 12:25:55 2015
#      by: PyQt4 UI code generator 4.10.4
#
# WARNING! All changes made in this file will be lost!

import sys
import os
from PyQt4 import QtCore, QtGui
try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8

    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)


class Ui_MainWindow(object):

    def setupUi(self, MainWindow):
        MainWindow.setObjectName(_fromUtf8("MainWindow"))
        MainWindow.resize(281, 216)
        MainWindow.setAcceptDrops(True)
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setAcceptDrops(True)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.gridLayout = QtGui.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName(_fromUtf8("gridLayout"))
        self.label = QtGui.QLabel(self.centralwidget)
        self.label.setAcceptDrops(True)
        self.label.setAlignment(QtCore.Qt.AlignCenter)
        self.label.setObjectName(_fromUtf8("label"))
        self.gridLayout.addWidget(self.label, 0, 0, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(_translate("MainWindow", "VHDL Formatter", None))
        self.label.setText(_translate("MainWindow", "拖拽.vhd到这里！", None))


class mw(QtGui.QMainWindow):

    def __init__(self, parent=None):
        super(mw, self).__init__(parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

    def dragEnterEvent(self, event):
        if event.mimeData().hasFormat('text/uri-list'):
            event.acceptProposedAction()

    def dropEvent(self, event):
        urls = [unicode(url.toString().replace('file:///','')) for url in event.mimeData().urls()]
        os.system('node vhdlformatter.js '+' '.join(urls))


app = QtGui.QApplication(sys.argv)
mainwindow = mw()
mainwindow.show()
sys.exit(app.exec_())
