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
}
