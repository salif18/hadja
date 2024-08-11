<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Support\Carbon;

class Stats_Controller extends Controller
{
    //OBTENIR LES VENTES JOURNALIERE DE LA SEMAINE
    public function dayStatsByWeek()
    {
        try {

            $debutDeSemaine = Carbon::now()->startOfWeek()->copy();
            $finDeSemaine = Carbon::now()->endOfWeek()->copy();
            $dateActuel = $debutDeSemaine->copy();
            $data = [];

            while ($dateActuel <= $finDeSemaine) {
                $total = Order::whereDate("created_at", $dateActuel)->sum("total");
                $data[] = [
                    "date" => $dateActuel->format("d-m-y"),
                    "total" => $total
                ];
                $dateActuel->addDay();
            }

            //LA SOMME TOTAL DE LA SEMAINE
            $totalHebdomendaire = Order::whereBetween("created_at", [$debutDeSemaine, $finDeSemaine])->sum("total");

            return response()->json([
                "status" => true,
                "stats" => $data,
                "totalHebdo" => $totalHebdomendaire
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
            ], 500);
        }
    }

    //OBTENIR LES VENTES JOURNALIERE DU MOIS
    public function dayStatsByMonth()
    {
        try {

            $debutDuMois = Carbon::now()->startOfMonth()->copy();
            $finDuMois = Carbon::now()->endOfMonth()->copy();
            $dateActuel = $debutDuMois->copy();
            $data = [];

            while ($dateActuel <= $finDuMois) {
                $total = Order::whereDate("created_at", $dateActuel)->sum("total");
                $data[] = [
                    "date" => $dateActuel->format("d-m-y"),
                    "total" => $total
                ];
                $dateActuel->addDay();
            }

            //LA SOMME TOTAL DU MOIS
            $totalMensuel = Order::whereBetween("created_at", [$debutDuMois, $finDuMois])->sum("total");

            return response()->json([
                "status" => true,
                "stats" => $data,
                "totalMensuel" => $totalMensuel
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
            ], 500);
        }
    }

    //STATS DE LANNEE
    public function yearStatsByMonth()
    {
        try {

            $debutDannee = Carbon::now()->startOfYear()->copy();
            $finDannee = Carbon::now()->endOfYear()->copy();
            $data = [];
            $totalAnnuel = 0;
            $orders = Order::whereBetween("created_at", [$debutDannee, $finDannee])->get()
                ->groupBy(function ($order) {
                    return Carbon::parse($order->created_at)->format("m-y");
                });

            foreach ($orders as $month => $order) {
                $total = $order->sum("total");
                $totalAnnuel += $total;
                $data[] = [
                    'month' => $month, // 'Y-m' format, ex: 2024-02
                    'total' => $total,
                ];
            }

            return response()->json([
                "status" => true,
                "stats" => $data,
                "totalAnnuel" => $totalAnnuel
            ], 200);
        } catch (\Exception $error) {
            return response()->json([
                "status" => false,
                "error" => $error->getMessage()
            ], 500);
        }
    }
}
