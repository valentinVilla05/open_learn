<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('califications', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('exam_id');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade'); 
            $table->foreign('exam_id')->references('id')->on('exams')->onDelete('cascade');
            $table->float('calification')->nullable();
            $table->timestamp('attempted_at')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'exam_id']); // An user only can have one qualification per exam;
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('califications');
    }
};
