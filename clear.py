import requests
import sys

# GitLab API base URL
GITLAB_URL = "https://gitlab.example.com"
try:
    API_TOKEN = sys.argv[1]
except IndexError:
    print("Where is <API_TOKEN> ? ")
    sys.exit(1) 

GROUP_IDS = ["95295627", "64209123"]  # Replace with the ID or path of the group

HEADERS = {
    "Private-Token": API_TOKEN
}

def get_group_projects(group_id):
    """Fetch all projects in the specified group."""
    projects = []
    page = 1

    while True:
        response = requests.get(
            f"{GITLAB_URL}/api/v4/groups/{group_id}/projects",
            headers=HEADERS,
            params={"page": page, "per_page": 100}
        )
        if response.status_code != 200:
            print(f"Failed to fetch projects: {response.text}")
            return []
        
        data = response.json()
        if not data:
            break

        projects.extend(data)
        page += 1

    return projects

def get_terminated_pipelines(project_id):
    """Fetch all terminated pipelines for a project."""
    pipelines = []
    page = 1

    while True:
        response = requests.get(
            f"{GITLAB_URL}/api/v4/projects/{project_id}/pipelines",
            headers=HEADERS,
            params={"status": "success", "page": page, "per_page": 100}
        )
        if response.status_code != 200:
            print(f"Failed to fetch pipelines for project {project_id}: {response.text}")
            return []
        
        data = response.json()
        if not data:
            break

        pipelines.extend(data)
        page += 1

    return pipelines

def delete_pipeline(project_id, pipeline_id):
    """Delete a pipeline by its ID."""
    response = requests.delete(
        f"{GITLAB_URL}/api/v4/projects/{project_id}/pipelines/{pipeline_id}",
        headers=HEADERS
    )
    if response.status_code == 204:
        print(f"Successfully deleted pipeline ID {pipeline_id} for project ID {project_id}")
    else:
        print(f"Failed to delete pipeline ID {pipeline_id} for project ID {project_id}: {response.text}")

def remove_terminated_pipelines_from_group(group_id):
    """Remove all terminated pipelines from projects in the group."""
    projects = get_group_projects(group_id)

    if not projects:
        print("No projects found in the group.")
        return

    for project in projects:
        project_id = project['id']
        project_name = project['name']

        print(f"Checking terminated pipelines for project {project_name} (ID: {project_id})...")
        pipelines = get_terminated_pipelines(project_id)

        if not pipelines:
            print(f"No terminated pipelines found for project {project_name} (ID: {project_id}).")
        else:
            for pipeline in pipelines:
                pipeline_id = pipeline['id']
                print(f"Deleting pipeline ID {pipeline_id} for project {project_name} (ID: {project_id})...")
                delete_pipeline(project_id, pipeline_id)

if __name__ == "__main__":
    for GROUP_ID in GROUP_IDS:
        remove_terminated_pipelines_from_group(GROUP_ID)
