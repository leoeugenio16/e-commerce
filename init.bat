@echo off

:: Inicializar backend
cd e-commerce_PCHub
call init-backend.bat

:: Inicializar frontend
cd ..\frontend-ecommerce
call init-frontend.bat