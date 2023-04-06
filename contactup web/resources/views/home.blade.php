<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="images/contact_up.png" />

        <title>Contact up</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
            <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css"
    integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous" />

      <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/22.1.6/css/dx.common.css" />
      <link rel="stylesheet" type="text/css" @if(session()->has('theme')) @if(session()->get('theme') == 0) href="https://cdn3.devexpress.com/jslib/22.1.6/css/dx.light.css" @else href="https://cdn3.devexpress.com/jslib/22.1.6/css/dx.dark.css" @endif @else href="https://cdn3.devexpress.com/jslib/22.1.6/css/dx.light.css" @endif />


        <style>
            body {
                font-family: 'Nunito', sans-serif;
            }
        </style>
    </head>
    <body class="dx-viewport">

        <div id="main"></div>
        <script src="{{asset("js/app.js")}}"></script>
    </body>
</html>
