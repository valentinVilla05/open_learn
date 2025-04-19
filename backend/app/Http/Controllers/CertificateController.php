<?php

namespace App\Http\Controllers;

use App\Models\Certificate;
use App\Models\Course;
use App\Models\User;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;

class CertificateController extends Controller
{
    public function getAllCertificatesFromUser($user_id)
    {
        $certificates = Certificate::where('user_id', $user_id)->get();

        if ($certificates->isEmpty()) {
            return response()->json(['message' => 'No certificates found for this user'], 404);
        }

        return response()->json($certificates, 200);
    }
    public function generateCertificate(Request $request, $user_id, $course_id)
    {
        // Check if the user has finished the course
        $certificateExists = Certificate::where('user_id', $user_id)->where('course_id', $course_id)->first();

        $userName = User::findOrFail($user_id)->name;
        $courseName = Course::findOrFail($course_id)->title;

        if ($certificateExists) {
            $certificateCode = $certificateExists->certificate_code;
            $ending_date = $certificateExists->ending_date->format('d/m/Y');

            return $this->certificatePDF($userName, $courseName, $ending_date, $certificateCode);
        }

        $certificateCode = Certificate::generateCode($user_id, $course_id);
        $ending_date = now()->format('d/m/Y');

        // Save the certificate to the database
        $certificate = Certificate::create([
            'user_id' => $user_id,
            'course_id' => $course_id,
            'certificate_code' => $certificateCode,
            'ending_date' => now(),
        ]);

        return $this->certificatePDF($userName, $courseName, $ending_date, $certificateCode);

    }
    function certificatePDF($userName, $courseName, $ending_date, $certificateCode)
    {
        $pdf = Pdf::loadHTML("
         <div style='text-align: center; font-family: sans-serif'>
            <h1>Certificate of Completion</h1>
            <p>This is to certify that</p>
            <h2>$userName</h2>
            <p>has completed the course</p>
            <h2>$courseName</h2>
            <p>on $ending_date</p>
            <p style='margin-top: 30px;'>Certificate Code: <strong>{$certificateCode}</strong></p>
            </div>
        ");

        // Return the PDF as a download
        return $pdf->stream("certificate_{$userName}_{$courseName}.pdf");
    }
}
