from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
from datetime import datetime

app = FastAPI()

# Base de données simulée en mémoire
courses = []
courses_id_counter = 1 # ompteurs pour générer des id uniques pour les cours

# Modèle de données pour un cours
class Course(BaseModel):
    title : str
    description: str
    time: str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
# Ajouter un cours
@app.post("/courses/")
def add_course(course: Course):
    global courses_id_counter
    new_course = {
        "id": courses_id_counter,
        "title": course.title,
        "description": course.description,
        "time": course.time
    }
    courses.append(new_course)
    courses_id_counter += 1
    return {"message": "Course ajouté avec succès", "course": new_course}

#Récupérer tous les cours
@app.get("/courses/")
def get_courses() ->List[dict]:
    return courses

# Page d'accueil (optionnel)
@app.get("/")
def root():
    return{"message": "Bienvenue sur l'API de gestion des cours!"}