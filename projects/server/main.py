from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Instantiates the app to serve the API 
app = FastAPI(
    title="Vest Vault",
    openapi_url=None,
    docs_url=None,
    redoc_url=None,
    swagger_ui_oauth2_redirect_url=None
)

# Add CORS middleware to allow calls from the front end to the API while on different ports
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Add functions to these routes

@app.get("/home")
def home():
    # Put a function here
    return { 'error': None, 'data': {} }

@app.get("/products")
def get_products():
    # put a function here
    return { 'error': None, 'data': {} }

@app.get("/products/{filter}/{value}")
def get_filtered_products():
    # put a function here
     return { 'error': None, 'data': {} }

