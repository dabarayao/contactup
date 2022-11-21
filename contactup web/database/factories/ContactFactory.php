<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ContactFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $nom = $this->faker->lastName();
        $prenoms = $this->faker->firstName();
        return [
            //
            'nom' => $nom,
            'prenoms' => $prenoms,
            'email' => $this->faker->unique()->safeEmail(),
            'phone' => $this->faker->phoneNumber(), // password
            'photo' => "https://placehold.co/300x300/f2b538/000000.png?text=" . $prenoms[0] . $nom[0]
        ];
    }
}

// contact::factory()->count(50)->create()