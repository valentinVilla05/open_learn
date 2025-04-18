<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Resource;

class ResourceController extends Controller
{
    // Method to get all resources
    public function showAllResources(){
        $resource = Resource::all();

        return response()->json($resource, 200); // Return the resources in JSON with 200 status
    }
    public function showResourceByCourseId(Request $request, $courseId){
        $resources = Resource::where('course_id', $courseId)->get(); //  We get the resources with the course_id passed by the user

        return response()->json($resources, 200); // Return the resources in JSON with 200 status
    }
    public function createResource(Request $request){
        $data = $request->validate([
            'course_id' => 'required|integer',
            'type' => 'required|in:document,video,link',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'limit_date' => 'nullable|date',
            'url' => 'nullable|url',
        ]);

        $resource = Resource::create($data); // We create the resource with the data passed by the user
        return response()->json(['meessage' => 'The resource was created succesfully'], 200);
    }

    public function updateResource(Request $request, $id){
        $resource = Resource::findOrFail($id); // We find the resource with the id passed by the user

        $data = $request->validate([
            'name' => 'string|max:255',
            'description' => 'nullable|string',
            'limit_date' => 'nullable|date',
            'url' => 'nullable|url',
        ]);
        
        $resource->update($data); // We update the resource with the new data 
        return response()->json(['message' => 'The resource was updated succesfully'], 200);
    }
    public function deleteResource(Request $request, $id){
        $resource = Resource::findOrFail($id); 
        $resource->delete(); 
        
        return response()->json(['message' => 'The resource was deleted succesfully'], 200);
    }
}