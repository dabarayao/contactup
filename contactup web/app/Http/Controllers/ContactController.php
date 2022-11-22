<?php

namespace App\Http\Controllers;

use App\Models\contact;
use App\Http\Requests\StorecontactRequest;
use App\Http\Requests\UpdatecontactRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;


class ContactController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $contact = contact::orderBy('created_at', 'DESC')->where("is_arch", false)->get();

        return json_encode($contact, JSON_UNESCAPED_SLASHES);
    }

    public function theme(Request $request)
    {
        //
        session()->put("theme", $request->appTheme);

        return "ok";
    }

    public function indexFav()
    {
        //
        $contact = contact::orderBy('created_at', 'DESC')->where(["is_fav" => true, "is_arch" => false])->get();

        return json_encode($contact, JSON_UNESCAPED_SLASHES);
    }

    public function indexArch()
    {
        //
        $contact = contact::where("is_arch", true)->get();

        return json_encode($contact, JSON_UNESCAPED_SLASHES);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\StorecontactRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StorecontactRequest $request)
    {
        //
        $path = NULL;

        if ($request->hasFile("image")) {


            $picture = Storage::putFile('public/contact', $request->image);
            $path = Storage::url($picture);
        }


        $contact = new contact;
        $contact->nom = $request->nom;
        $contact->prenoms = $request->prenoms;
        $contact->email = $request->email;
        $contact->phone = $request->phone;
        $contact->photo = $path != null ? $path : null;
        $contact->save();

        return redirect()->route('home');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\contact  $contact
     * @return \Illuminate\Http\Response
     */
    public function show(contact $contact)
    {
        //

        return json_encode($contact, JSON_UNESCAPED_SLASHES);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\contact  $contact
     * @return \Illuminate\Http\Response
     */
    public function edit(contact $contact)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdatecontactRequest  $request
     * @param  \App\Models\contact  $contact
     * @return \Illuminate\Http\Response
     */

    public function favorite(contact $contact, UpdatecontactRequest $request)
    {
        //
        $contact->is_fav = $request->isFav == "true" ? false : true;
        $contact->save();
    }

    public function archive(contact $contact, UpdatecontactRequest $request)
    {
        //
        $contact->is_arch = $request->isArch == "true" ? false : true;
        $contact->save();
    }


    public function update(UpdatecontactRequest $request, contact $contact)
    {
        //
        $path = NULL;

        if ($request->hasFile("image")) {


            $picture = Storage::putFile('public/contact', $request->image);
            $path = Storage::url($picture);
        }


        $contact->nom = $request->nom;
        $contact->prenoms = $request->prenoms;
        $contact->email = $request->email;
        $contact->phone = $request->phone;
        if ($path != null) {
            $contact->photo = $path;
        }

        // Delete contact picture from mobile
        if (isset($request->delImage)) {
            $contact->photo = null;
        }
        $contact->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\contact  $contact
     * @return \Illuminate\Http\Response
     */
    public function destroyMob($contact)
    {
        //
        $contacts = contact::find($contact);
        if ($contacts != null) {
            $contacts->delete();
            return "ok";
        } else {
            return "error";
        }
    }

    public function destroyMulMob($contact)
    {
        //

        $piece = explode(";", $contact);
        $result = "failed";

        foreach ($piece as $pieces) {
            $delCont = contact::find($pieces);
            global $result;

            if ($delCont != null) {
                $delCont->delete();
                $result = "success";
            }
        }

        return $result;
    }

    public function archiveMul($contact)
    {
        $piece = explode(";", $contact);
        $result = "failed";

        foreach ($piece as $pieces) {
            $archCont = contact::find($pieces);
            global $result;

            if ($archCont != null) {
                $archCont->is_arch = !$archCont->is_arch;
                $archCont->save();
                $result = "success";
            }
        }

        return $result;
    }

    public function destroy(contact $contact)
    {
        //
    }
}