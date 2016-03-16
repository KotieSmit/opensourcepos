<?php
require_once("report.php");
class Specific_cashup extends Report
{
    function __construct()
    {
        parent::__construct();
    }

    public function getDataColumns()
    {
        return array
        (
            $this->lang->line('reports_cashups_cashup_id'),
            $this->lang->line('reports_date'),
            $this->lang->line('reports_payment_type'),
            $this->lang->line('reports_reported_value'),
            $this->lang->line('reports_declared_value'),
            $this->lang->line('reports_variance')
        );
    }

    public function getData(array $inputs)
    {
        $this->db->select('cashups_declared.cashup_id , language_id, closed as date_time,  SUM(reported_total) as reported_value, SUM(declared_value) as declared_amount,
            (SUM(reported_total) - SUM(declared_value)) as variance' ,  false);
        $this->db->from('cashups_declared ');
        $this->db->join('payment_methods', 'cashups_declared.payment_method_id=payment_methods.payment_method_id');
        $this->db->join('cashups', 'cashups_declared.cashup_id=cashups.cashup_id');

        $this->db->where('date(closed) BETWEEN "'. $inputs['start_date']. '" and "'. $inputs['end_date'].'"' );
        $this->db->where('cashups_declared.employee_id = "'. $inputs['employee_id'].'"');
        $this->db->group_by("language_id");
        $this->db->group_by("cashup_id");
        $this->db->group_by("date_time");
        $this->db->order_by("cashup_id");
        return $this->db->get()->result_array();


    }

    public function getSummaryData(array $inputs)
    {
        $this->db->select('sales_payments.payment_type as name, SUM(payment_amount) as value ' ,  false);
        $this->db->from('sales_payments');
        $this->db->join('sales', 'sales.sale_id=sales_payments.sale_id');
        $this->db->where('date(sale_time) BETWEEN "'. $inputs['start_date']. '" and "'. $inputs['end_date'].'"' );
        $this->db->where('employee_id = "'. $inputs['employee_id'].'"');
        $this->db->group_by("payment_type");
        return $this->db->get()->result_array();
    }
}
?>